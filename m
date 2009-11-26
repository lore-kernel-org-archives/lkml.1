Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZKZLPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZKZLPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbZKZLPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:15:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:58525 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203AbZKZLPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:15:18 -0500
Message-ID: <4B0E634B.8070506@suse.cz>
Date: Thu, 26 Nov 2009 12:15:23 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: display an error message when aborting
References: <1259124522-26050-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1259124522-26050-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.11.2009 05:48, Mike Frysinger wrote:
> If the Kconfig option causes an open() failure (like one that starts with
> an underscore), there should be an error message shown since we're going
> to be exiting with an error code.  Otherwise, the reason for the failure
> can really only be diagnosed with strace or something similar.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  scripts/kconfig/confdata.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index b55e72f..e2644b4 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -640,6 +640,8 @@ static int conf_split_config(void)
>  		fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
>  		if (fd == -1) {
>  			if (errno != ENOENT) {
> +				conf_warning("sym '%s' with path '%s': %s",
> +					     sym->name, path, strerror(errno));
>  				res = 1;
>  				break;
>  			}

I agree that there definitely needs to be some error reporting (and not
only here but in many more places, look e.g. at conf_write() or
conf_write_autoconf()), but why use conf_warning() for this? It will
prefix the error message with "include/config/auto.conf:<last lineno>",
which has nothing to do with the path that could not be opened.

Michal

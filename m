Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbYGKTWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbYGKTWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbYGKTTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:19:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759932AbYGKTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:19:44 -0400
Date: Fri, 11 Jul 2008 12:18:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Guilak <guilak@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       torvalds@linux-foundation.org, daniel@danielguilak.com
Subject: Re: [PATCH] init/version.c: Silenced sparse warning by declaring
 the version string.
Message-Id: <20080711121833.f03200e6.akpm@linux-foundation.org>
In-Reply-To: <1215552069.10304.6.camel@dguilak-desk>
References: <1215552069.10304.6.camel@dguilak-desk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2008 14:21:09 -0700 Daniel Guilak <guilak@linux.vnet.ibm.com> wrote:

> Signed-off-by: Daniel Guilak <daniel@danielguilak.com>

Please always quote the warning or error message in the changelog when
fixing it.  Although it's pretty obvious in this case.

>  init/version.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/init/version.c b/init/version.c
> index 9d17d70..041fd82 100644
> --- a/init/version.c
> +++ b/init/version.c
> @@ -16,6 +16,7 @@
>  #define version(a) Version_ ## a
>  #define version_string(a) version(a)
>  
> +extern int version_string(LINUX_VERSION_CODE);
>  int version_string(LINUX_VERSION_CODE);
>  
>  struct uts_namespace init_uts_ns = {

hrm, what does this thing do?  Seems to define 

int Version_132634;

Then sticks that in the symbol table (and wastes a bit of bss).

Does anything use it?

Could it be made static?



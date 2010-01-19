Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584Ab0ASQi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0ASQi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542Ab0ASQi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:38:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0ASQi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:38:26 -0500
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
From: Steven Rostedt <srostedt@redhat.com>
To: John Kacur <jkacur@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1001191723030.5999@localhost.localdomain>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org>
	 <20100119142545.GB3473@hack>
	 <520f0cf11001190822t6d3221bco20739d586608bfde@mail.gmail.com>
	 <alpine.LFD.2.00.1001191723030.5999@localhost.localdomain>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 19 Jan 2010 11:37:55 -0500
Message-Id: <1263919075.2737.134.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 17:29 +0100, John Kacur wrote:

> diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> index 0d80082..1803d2e 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -238,7 +238,8 @@ foreach my $makefile (@makefiles) {
>  my %modules;
>  
>  # see what modules are loaded on this system
> -open(LIN,"/sbin/lsmod|") || die "Cant lsmod";
> +# If lsmod isn't in the sbin dir, check if it is in the path
> +open(LIN,"/sbin/lsmod|") || open(LIN,"lsmod|") || die "Cant lsmod";

I've tried this before, but it gives an error that the "|" pipe failed.

-- Steve


>  while (<LIN>) {
>  	next if (/^Module/);  # Skip the first line.
>  	if (/^(\S+)/) {


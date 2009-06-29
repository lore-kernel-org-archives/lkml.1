Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZF2Ctr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZF2Ctr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZF2Ctk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:49:40 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:44844 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZF2Ctj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e3yCloYdsLRdSqyl2N9zmYg9cT6ps42RQkuFk3ayaUpJtIDgv6Hb7vihGBvfT1iVlr
         2Us4j8q13BzRkAMGMFspUpPCokWJHlEy/LGdLUtvUV+QcVBm8p8H3MkJJ9MsWjtFMFvq
         wn97M0K3h5NKaGNhD/dDE80ZX5jU1A9M/FYTY=
Date: Mon, 29 Jun 2009 10:51:46 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Dick Streefland <dick@streefland.net>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090629025146.GA5998@cr0.nay.redhat.com>
References: <20090623225245.GA10443@streefland.net> <20090624021506.GA5871@cr0.nay.redhat.com> <20090624114607.GA10817@streefland.net> <20090624133148.GA12878@streefland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624133148.GA12878@streefland.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 03:31:48PM +0200, Dick Streefland wrote:
>On Wednesday 2009-06-24 13:46, Dick Streefland wrote:
>| Because I don't want to rely on a particular version of grep, I've
>| modified the script to use perl instead. I hope that's OK. Below is
>| a new patch.
><snip>


Sorry for the delay, I missed this patch...

>
>I found a way to work around the differences in behavior of grep.
>Older versions of grep report the byte offset of the start of the
>line instead of the byte offset of the pattern. By using tr to
>make sure the pattern is always at the start of a "line", both old
>and new versions of grep can be used.


This is very tricky...

<snip>

>+
>+gz1='\037\213\010'
>+gz2='01'
>+cf1='IKCFG_ST\037\213\010'
>+cf2='0123456789'
>+
>+dump_config()
> {
>-	echo "  usage: extract-ikconfig [b]zImage_filename"
>-}
>-
>-clean_up()
>-{
>-	if [ "$TMPFILE" != "" ]; then
>-		rm -f $TMPFILE
>+	if	pos=`tr "$cf1\n$cf2" "\n$cf2=" < "$1" | grep -abo "^$cf2"`


Does this work?
My quick test shows no...

I still can't get the right offset number with this trick.

P.S. My grep is 2.5.1.

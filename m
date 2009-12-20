Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbZLTIsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbZLTIsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 03:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZLTIsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 03:48:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:45645 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZLTIsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 03:48:13 -0500
Date: Sun, 20 Dec 2009 09:46:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mjt@tls.msk.ru,
       mmarek@suse.cz
Subject: Re: 2.6.33-rc1 Reboot right after bootloader
Message-ID: <20091220084656.GA485@merkur.ravnborg.org>
References: <20091219233457.GA4288@trillian.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091219233457.GA4288@trillian.comsick.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 12:34:57AM +0100, Michael Guntsche wrote:
> Good evening,
> 
> I took me some time but I tracked down my reboot problem. The culprit is
> commit 
> 
> 4a2ff67c88211026afcbdbc190c13f705dae1b59: kbuild: fix bzImage build for
> x86
> 
> The system I am compiling the kernel on has dash as its defaults shell.
> With the commit applied I get an instant reboot, reverting the patch
> makes it work again. 
> If I switch my default shell to bash it works BOTH times.
> I do not know why the shell makes a difference here though.
> The version of dash is 0.5.5.1 from debian unstable.

Hi Michael & Oliver.

Just to check what is going wrong here could you try to execute the following two commands:
printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
/usr/bin/printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
echo -ne \\xa8\\x51\\x37\\x00 > x ; hexdump x

Please try as above and also with full path to printf (/usr/bin/printf)

On my system it looks like this:

$ printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 51a8 0037
0000004
$ /usr/bin/printf  \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 51a8 0037
0000004
$ echo -ne \\xa8\\x51\\x37\\x00 > x ; hexdump x
0000000 51a8 0037
0000004

	Sam

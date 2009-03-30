Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZC3N21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZC3N21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZC3N2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:28:18 -0400
Received: from devzero.co.uk ([91.197.32.156]:49049 "EHLO
	clarent.devzero.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZC3N2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:28:18 -0400
X-Greylist: delayed 1824 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2009 09:28:18 EDT
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot
Date: Mon, 30 Mar 2009 13:57:16 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.28-7-generic; KDE/4.2.0; i686; ; )
Cc: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com> <9b1675090903292155q6d221da1q6d19b7bca9cbe4e6@mail.gmail.com> <9b1675090903300033y65dd4bc5td9157de735a76dd9@mail.gmail.com>
In-Reply-To: <9b1675090903300033y65dd4bc5td9157de735a76dd9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903301357.17076.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009 08:33:06 Trenton D. Adams wrote:
[snip]
> Then, I mark the current (something in 2.6.28) one as good...
> # good: [86b3aa390b4b9925f16a21b98441fd7abdb9fff2] Merge branch
> 'topic/ca0106' into to-push
> git bisect good 86b3aa390b4b9925f16a21b98441fd7abdb9fff2
>
> And I get this...
> tdamac linux # git bisect good
> Bisecting: 89 revisions left to test after this
> [b83923a3931a43df7397a7491f0c9d9b9d46624a] ALSA: hda - minor HDMI code
> cleanups tdamac linux # make kernelversion
> 2.6.27
>
> So, if I mark that as good (arbitrarily because it's pre 2.6.28 which
> I assume is good), it jumps back to pre 2.6.28 release
> tdamac linux # git bisect good
> Bisecting: 46 revisions left to test after this
> [0ff555192a8d20385d49d1c420e2e8d409b3c0da] Merge branch 'fix/hda' into
> topic/hda tdamac linux # make kernelversion
> 2.6.28-rc8
>
> And, if I mark the 2.6.27 one as bad, it just remains on 2.6.27.

Don't worry about the kernel version it generates. Git bisections traverse 
merged branches, including those that weren't rebased before being merged (in 
fact the preferred work flow). I usually add "-bisect" to CONFIG_LOCALVERSION 
so I can isolate my work in progress bisection from system kernels.

You can trust git to involve only relevant commits between your initial "good" 
and "bad" markers; don't add more unless you have to. Sometimes you may need 
to "shift" the bisection midpoint if you encounter build breakage. You should 
be able to find comments Linus made on the subject by searching the LKML 
archive for "git bisect visualize".

-- 
Cheers,
Alistair.

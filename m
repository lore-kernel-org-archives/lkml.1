Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYKFKtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYKFKtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYKFKsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:48:51 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:21539 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753466AbYKFKsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:48:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=buON7wD23exuIjMy9eh9spOH6psdJdbJ3FOzqo0GZ+H5OI7UO2o3f0pYnztbm2HZY0qoMABortwHXTC/AynVTWfJYrN7jydocRz/wdfnr9MGos728CktO3pIVgNaodiiWdkOFWuUjsr2FYBhFglKTg4LE+1eM0ypviityHRXthU=  ;
X-YMail-OSG: JQ8lH08VM1k9xwZpBSuUMvaWOQGolXzy9NNBvFuEMo9a9NW.jFRQuDr32RBfMGLizCBONniQt8FJ8PqaqVPUykmSH4P.fY_37y3Y9d6f2xeraAZmLZORkWUIrRyi919Voqb8As8K7hFCa7JYxnisUUOVgepW3JlPQtGqkg7mByXxTlBYIictwfa_AyTI
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
Date: Thu, 6 Nov 2008 21:48:39 +1100
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <4901F375.3020202@vlnb.net> <200810291125.31547.nickpiggin@yahoo.com.au> <490B4A6A.7020200@vlnb.net>
In-Reply-To: <490B4A6A.7020200@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811062148.39713.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 November 2008 05:11, Vladislav Bolkhovitin wrote:
> Nick Piggin wrote:
> > On Wednesday 29 October 2008 06:38, Vladislav Bolkhovitin wrote:
> >> Nick Piggin wrote:
> >>> On Saturday 25 October 2008 03:10, Vladislav Bolkhovitin wrote:
> >>>> Hi,
> >>>>
> >>>> During recent debugging session of my SCSI target SCST
> >>>> (http://scst.sf.net) I noticed many
> >>>>
> >>>> WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x51/0x66()
> >>>>
> >>>> messages in kernel log on the initiator. I attached the full log of
> >>>> several of them.
> >>>>
> >>>> My target was buggy and I was working on fixing it, but I suppose
> >>>> Linux should handle such failures more gracefully. In all the cases
> >>>> the target had one type of failure: it "ate" a SCSI command and never
> >>>> returned result of it.
> >>>
> >>> Right. This is one of the warnings I see in my fault-injection testing.
> >>> It is fixed by my patch to clean up and improve the page and buffer
> >>> error handling in the vm/fs.
> >>
> >> Can you specify which patch you referring? Is it in 2.6.27?
> >
> > It's just an RFC at the moment which I posted to fsdevel. Not in 2.6.27.
>
> I see. I'm looking forward to see it in 2.6.28 or .29. This is really a
> needed work.

Hopefully. Unfortunately it doesn't exactly make the filesystems
themselves more robust against failure. That needs to be done on
a case by case basis.


> BTW, have you even seen in your fault-injection testing that after
> receiving a failure from a SCSI device during heavy load ext3 file
> system mounted on it gets corrupted and journal replay on remount
> doesn't repair it, only manual e2fsck helps? I've many times seen that,
> including cases when the target was remaining up and fully functional.
> See, e.g., "MOANING MODE ON" part in
> http://marc.info/?l=linux-scsi&m=121932252324432&w=2. I haven't checked
> that case since then, although I see such corruptions quite often. But
> in all them I can't so clearly say that it isn't a target's failure.

I haven't seen that, but I'm not exactly testing for filesystem
robustness to errors, but more of core vm/fs layer robustness, so
I'm mainly trying to inject errors into data portion of inodes.

I think the ext3 development list should be interested in your
report.

Thanks,
Nick

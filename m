Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYHRTxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYHRTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYHRTwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:52:37 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:35739 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753863AbYHRTwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:52:36 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 15:52:36 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=UvERc+B2lHT5ocxKrOItnA0U96jKZADufKDrJwiCUQaeRKfDcg+QmuLALn+xDvNHCakRsyq188cT9xvM0Nxmr5u7oJ3VPI7QsoEvm2wf1bQZlO8EeYKrjIdS7uSNvsvnbIhxAJCLbhKV4M3826uYGW6xBq2TI79TbxNlqVnX4nI=;
X-YMail-OSG: H2ngipUVM1kZweutnW1VbQ7Pezq4I3FfB1vOj_5OAf7dRTOurQE_WI3VsGEO._KgmAedcO8kP3Ft2xlVYVztW8FFq5MGiuoStOBoZ2qBWETmp77Yln_0ojGUAAUJ8u3MQFxXxBWu4HGb1AUyaw0dHXo-
Date: Mon, 18 Aug 2008 12:45:47 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: Linux 2.6.26 edac errors and ASUS P5W DH Deluxe motherboard
To: Andy Chittenden <andyc@bluearc.com>, linux-kernel@vger.kernel.org
In-Reply-To: <0F10A59FDFFDFD4E9BEBD7365DE672550214F027@uk-email.terastack.bluearc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <99716.17944.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andy Chittenden <andyc@bluearc.com> wrote:

> I've just installed the linux-image-2.6.26-1-amd64 debian package on
> three of our ASUS P5W DH Deluxe based machines and they've all started
> spewing out messages:
> 
> Message from syslogd@savage at Mon Aug 18 14:01:52 2008 ...
> savage kernel: [   74.389644] EDAC MC0: UE page 0x7fe03, offset 0x0,
> grain 128, row 2, labels ":": i82975x UE
> 
> Message from syslogd@savage at Mon Aug 18 14:01:53 2008 ...
> savage kernel: [   75.555862] EDAC MC0: UE page 0x7fd44, offset 0x0,
> grain 128, row 2, labels ":": i82975x UE
> 
> Message from syslogd@savage at Mon Aug 18 14:01:54 2008 ...
> savage kernel: [   76.628039] EDAC MC0: UE page 0x7fd41, offset 0x0,
> grain 128, row 2, labels ":": i82975x UE
> 
> Message from syslogd@savage at Mon Aug 18 14:01:55 2008 ...
> savage kernel: [   77.629260] EDAC MC0: UE page 0x7fd27, offset 0x0,
> grain 128, row 2, labels ":": i82975x UE
> 
> every second.
> 
> I've removed that kernel package and they're running previous versions
> of the kernel (eg linux-image-2.6.25-2-amd64) happily. I've run memtest
> on one of them with no problems. So, anyone got any ideas what's causing
> this? (FWIW the machines have all got ECC memory in them).
> 
> -- 
> Andy, BlueArc Engineering


I don't know which version of the  source code was used in the 25 or the 26 versions of the debian
package, but it might be that the later one is really finding errors as I remember there was some
patches against the i82975x module.

The reports printed above are consistent. They are ALL in Chip Select Row 2, yet all 3 of the
machines are outputting messages.

Are they ALL the same row, or are they different rows? If different, they could be legit. The same
row there might be an issue.

Reading the manual for the mobo (http://support.asus.com/download/download.aspx?SLanguage=en-us) I
see that there are 4 slots for memory:

DIMM_A1
DIMM_A2
DIMM_B1
DIMM_B2

In the output above, you can see the following:

labels ":"

When properly set by edac-utils (http://sourceforge.net/projects/edac-utils/) user space support
package (IF the target motherboard is set in its database) the labels' field will be composed of
the offending DIMM, like "DIMM_A2" or such. This aids in identifying the problem DIMM. If you have
this already installed, you might need to add to the motherboard database, your motherboard's DIMM
labels to see it.

Since I don't have one of these chipsets, is it possible I could access to one or more of these
machines to take a look around?

doug t


W1DUG

Return-Path: <linux-kernel-owner+w=401wt.eu-S2992584AbXDLPhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992584AbXDLPhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992586AbXDLPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:37:05 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38616 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992584AbXDLPhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:37:04 -0400
Message-ID: <461E5212.8070807@zytor.com>
Date: Thu, 12 Apr 2007 08:36:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Egmont Koblinger <egmont@uhulinux.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412091120.GA15666@uhulinux.hu>
In-Reply-To: <20070412091120.GA15666@uhulinux.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger wrote:
> 
> I don't think width information for characters in BMP is going to change
> that often.
> 
> By the way, a note about the size: the larger one of the two tables is
> unused and hence optimised away by the compiler. I just left in the source
> so that it only takes a minor modification for people go get a different
> sane behavior (ie. ignore combining chars). So only the small table, with 11
> pairs of longs (88 bytes) are compiled to the kernel.
> 

Every version has added combining chars.  But anyway, please don't leave 
unused code in the kernel.  I agree doublewidth characters are largely 
range-based and thus not all that likely to change.

>> At least please put them in a separate .c file and include a script to 
>> generate them clean from UnicodeData.txt.
> 
> I'll look at it, but I didn't want to alter the building procedure, modify
> Makefiles... Or do you mean I should only ship the generated .c file plus
> the script, instead of the (1MB) UnicodeData.txt and generating it compile
> time? Sounds reasonable...

Right.  However, see above.

>> Besides, would it not make more sense to have a single table with the 
>> width information, if you insist on having one, instead of multiple ones?
> 
> I've been thinking on it and I'm not sure which one the right way is. The
> reason for choosing this was probably that this way information that is not
> used by the code can be omitted by the compiler.

Then let's leave it out of the source.

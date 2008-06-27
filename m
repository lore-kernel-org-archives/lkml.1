Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYF0LcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYF0LcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYF0Lb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:31:58 -0400
Received: from smtp.fullrate.dk ([89.150.129.5]:51208 "EHLO dns2.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYF0Lb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:31:58 -0400
Message-ID: <4864CFA5.9050901@agner.org>
Date: Fri, 27 Jun 2008 13:31:49 +0200
From: Agner Fog <agner@agner.org>
Organization: agner@agner.org
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com>
In-Reply-To: <4862ECAB.1040402@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

>the linux kernel policy is loud and clear; this is more an OS policy as
>it is a platform ABI issue.

It doesn't help to say it "loud and clear" in a closed mailing list. It has to go into an official document that people can find, and the ABI is the most natural place to look for such rules. The ABI is hard enough to find. Is there an official OS policy document somewhere that I haven't found? Please point me to an authoritative document.

You can't blame driver makers for using XMM or YMM registers in inline assembly or intrinsic functions or calling their own libraries or using a different compiler unless there is an official rule against it written in some official document that is easy to find. If you want to move data in a device driver, it is tempting indeed to use the largest register size available.

I will write the rules in my manual, but it is not authoritative.


H. Peter Anvin wrote:
 >Sadly, AVX repeats the mistakes of SSE1, and doesn't implement proper 
wide support for integer operations.
 >It has the basic bitwide stuff, which makes it usable for RAID-5, but 
it doesn't extend MMX (which SSE2
 >eventually got around to), so it's not usable for RAID-6.  I'd hoped 
to find a VPERM-style instruction, like
 >SSE5 has :(

There is no problem in using the floating point permutation instructions 
on integer data. They will not generate exceptions or anything on 
denormal numbers. Only the smallest data size is 32 bits, of course. 
Integer YMM instructions will probably come in a later version.

Note: Please Cc: me on answers, I am not on the mailing list.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZD0WT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZD0WT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZD0WTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:19:50 -0400
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:43400 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754899AbZD0WTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:19:49 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 18:19:49 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=damore.org;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Hu/DycfpJRcFmv+FkS/vS08IGkG61gJ0vSATUvLtGKbdks63ikbGhBLDH82Al/ygpFfAD74kxQyGSam43cbFWPgtbYFDMMaCIeWtzc9ed3rWxpY2ARx5UNgyNztga186;
Message-ID: <49F62DF4.5070709@damore.org>
Date: Mon, 27 Apr 2009 15:13:08 -0700
From: "Garrett D'Amore" <garrett@damore.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081201)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, pierre@ossman.eu,
       sdhci-devel@lists.ossman.eu,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Sdhci-devel] SDHCI driver runnining in aspire one, allows to
 write to R/O SD cards
References: <1240219764.13640.5.camel@maxim-laptop>	 <49ED0865.9030603@gmail.com>  <1240524632.20871.0.camel@maxim-laptop>	 <1240759276.10972.0.camel@maxim-laptop>  <49F5F57D.3010700@damore.org> <1240859254.11237.8.camel@maxim-laptop>
In-Reply-To: <1240859254.11237.8.camel@maxim-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2225:box374.bluehost.com:damoreor:damore.org} {sentby:smtp auth 192.18.43.225 authed with garrett+damore.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> On Mon, 2009-04-27 at 11:12 -0700, Garrett D'Amore wrote:
>   
>> As an extra data point, my sdhost driver in OpenSolaris works fine on 
>> the AA1.. it does see that the cards are locked, and refuses to allow 
>> them to be mounted read/write.
>>
>> This leads me to believe that the original linux problem is one of two 
>> things:
>>
>> * either a bug in the linux code, or
>> * busted circuit/hardware on a specific unit (i.e. a damaged unit)
>>
>> I believe that if the Linux code was buggy here, the problem would be 
>> reproducible on all platforms, not just the AA1.  So my inclination, 
>> barring independent confirmation, is that most likely there are one ore 
>> more defective units out there.
>>
>> Note that the AA1 also has buggy BIOS -- OpenSolaris can't "see" the 
>> cards (registers aren't properly initialized) unless they are present 
>> when the unit first powers up.
>>     
>
> But, why it works in windows?
>   

The Microsoft PCI code base probably is more willing to "work around" 
BIOSes that don't properly configure PCI configuration registers... this 
is an outstanding RFE for Solaris.

The Windows code base also has some other unrelated quirks in it -- it 
uses DAT3 for card presence detection instead of the card detect bit in 
the sdhci controller, for example.   (It also doesn't support MMC, which 
is to blame for some of the bastardized controller hacks that mfgrs like 
Ricoh have done to separate their MMC and SDcard handling into separate 
PCI functions.  Yes, that's a hardware workaround for a software bug!  
Go figure -- its what happens when one software company has a virtual 
monopoly...)

    -- Garrett
> Regards,
> 	Maxim Levitsky
>
>   


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZD3G2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZD3G2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbZD3G2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:28:06 -0400
Received: from web50112.mail.re2.yahoo.com ([206.190.39.149]:42356 "HELO
	web50112.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750714AbZD3G2F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:28:05 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2009 02:28:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=nRphHaB2H3uvNavf7vd1o+8uSIPzjoAtYWgE6KKbFI7p+m27vu7YFmOI9g3KQwQUDQ2OI93HZLBNAXWMFOrVC+bSllKF55ib1CMsa4Prr715/IpxZ9j6qSk8W5VsFyn0r7ji23N19iIXZ+re2QWQD0dOVBHu6TGowegd9n2nD44=;
Message-ID: <327494.52472.qm@web50112.mail.re2.yahoo.com>
X-YMail-OSG: Fd3c9AYVM1kwZDYhFrIH2lMu6tFnsAp4hHDUlBLo.qDdSZw9hhCeTdkLk7wvG7obSY7IPa3XAbJ.OqkK9TJx4GrNdeyyT3IFuFIh8ObmrMxbROBaa_Lau.wMEzlTwttfVRc.ANcDGSDFXjUvPN0E.GCMj1kEuxQxuvfrhe2aQrdsN9qUvdkQBVmy0EivW9655kZm0hmzQRanxmIf.ZTFCSP_np5gX_9a33SxeuP7ALQiQJXX7X7xhhy3ZFuKXlFnnqAhyssh7q.vaYSmFPtDyZ2V0ixBQq9wmNMBvTu8Ba3U1dX4XfeL1tsXGSHdV3s8
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Wed, 29 Apr 2009 23:21:20 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, borislav.petkov@amd.com, greg@kroah.com,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Wed, 4/29/09, Ingo Molnar <mingo@elte.hu> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
> To: "Andrew Morton" <akpm@linux-foundation.org>
> Cc: torvalds@linux-foundation.org, borislav.petkov@amd.com, greg@kroah.com, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Wednesday, April 29, 2009, 1:53 PM
> 
> * Andrew Morton <akpm@linux-foundation.org>
> wrote:
> 
> > On Wed, 29 Apr 2009 21:23:26 +0200
> > Ingo Molnar <mingo@elte.hu>
> wrote:
> > 
> > > > > > +   
>     if (CSFound >= 0) {
> > > > > > +   
>         *node_id = NodeID;
> > > > > > +   
>         *channel_select =
> ChannelSelect;
> > > > > > +   
>     }
> > > > > > +    }
> > > > > > +
> > > > > > +    return
> CSFound;
> > > > > > +}
> > > > > 
> > > > > this function is probably too large,
> and also it uses some weird 
> > > > > hungarian notation coding style. Please
> dont do that! It's 
> > > > > completely unacceptable.
> > > > 
> > > > These identifers (or at least,
> DctSelBaseOffsetLong, which is the 
> > > > only one I googled for) come straight out of
> the AMD "BIOS and 
> > > > Kernel Developer's Guide".
> > > > 
> > > > Sucky though they are, there's value in
> making the kernel code 
> > > > match up with the documentation.
> > > 
> > > I'm generally resisting patches that hungarinize
> arch/x86/ (and heck 
> > > there's been many attempts ...) but there's some
> conflicting advice 
> > > here. I've Cc:-ed Linus, maybe he has an opinion
> about this.
> > > 
> > > My gut reaction would be 'hell no'. There's
> other, structural 
> > > problems with this code too, and doing some saner
> naming would 
> > > mostly be a sed job and would take minimal amount
> of time. The 
> > > naming can still be intuitive. The symbols from
> the documentation 
> > > can perhaps be mentioned in a couple of comments
> to establish a 
> > > mapping.
> > 
> > I think I disagree.  For those identifiers which
> map 1:1 with the 
> > manufacturer's document, the ugliness involved in
> exactly copying 
> > the manufacturer's chosen identifiers is outweighed by
> the benefit 
> > of exactly copying the manufacturer's chosen
> identifiers.
> > 
> > Of course, we don't have to use StinkyIdentifiers
> anywhere else.  
> > And the nice thing about that is that when one reads
> the code and 
> > comes across a StinkyIdentifier, one immeditely knows
> that it's an 
> > AMD-provided thing rather than a Linux-provided
> thing.
> > 
> > Zillions of StinkyIdentifiers get merged via this
> logic.
> 
> Andrew, for heaven's sake, please review the patchset - as
> i did.
> 
> The thing is, up to 12/21, the patches look like normal
> Linux 
> patches. (there's problems with them too, but on a
> different level)
> 
> Then do the StinkyIdentifiers show up, in full force:
> 
> +static int f10_match_to_this_node(struct amd64_pvt *pvt,
> int DramRange,
> +               
>            
>    u64 SystemAddr,
> +               
>            
>    int *node_id,
> +               
>            
>    int *channel_select)
> +{
> +       int CSFound = -1;
> +       int NodeID;
> +       int HiRangeSelected;
> +       u32 IntlvEn, IntlvSel;
> +       u32 DramEn;
> +       u32 Ilog;
> +    u32 HoleOffset, HoleEn;
> +       u32 InputAddr, Temp;
> +       u32 DctSelBaseAddr,
> DctSelIntLvAddr;
> +       u32 DctSelHi;
> +       u32 ChannelSelect;
> +       u64 DramBaseLong,
> DramLimitLong;
> +    u64 DctSelBaseOffsetLong,
> ChannelAddrLong;
> 
> Tell me, how is 'SystemAddr' or 'Temp' or 'Ilog' an AMD
> document 
> thing?
> 
> I have a much simpler explanation really: someone got
> really bored 
> at converting some code written For Another OS, somewhere
> in the 
> middle - and started plopping Other OS Code into a Linux
> driver ...
> 
> I dont mind the occasional _constant_ that tells us a hw
> API detail 
> in whatever externally dictated style - but this thing
> stinks 
> HeadToToe ... ;-)
> 
>     Ingo
> 

I think I didn't reply to ALL on this, so sorry for a possible repost.

Right from the BKDG from the AMD website is the following reference code.

The format is lost in the mailing, but it IS the AMD reference code. This code also lacks the fixes for 2 bugs I found and which AMD emailed me and which is in the driver patches.  I did do some refactoring and tried to break the monolithic monster into a main function with supporting functions, I think this adds to the understanding somewhat. 

So, I am looking for what IS the policy for utilizing mfger's reference code in a linux driver?

Keeping the StinkyIdentifiers does help when referencing the the reference code. Maybe with Boris' help, we can get AMD to update their document with a better linux version of the reference code:

doug t


31116 Rev 3.06 - March 26, 2008 AMD Family 10h Processor BKDG
Page 67

(int,int,int,int) TranslateSysAddrToCS((uint64)SystemAddr){
int SwapDone, BadDramCs;
int CSFound, NodeID, CS, F1Offset, F2Offset, F2MaskOffset, Ilog, device;
int HiRangeSelected, DramRange;
uint32 IntlvEn, IntlvSel;
uint32 DramBaseLow, DramLimitLow, DramEn;
uint32 HoleOffset, HoleEn;
uint32 CSBase, CSLimit, CSMask, CSEn;
uint32 InputAddr, Temp;
uint32 OnlineSpareCTL;
uint32 DctSelBaseAddr, DctSelIntLvAddr, DctGangEn, DctSelIntLvEn;
uint32 DctSelHiRngEn,DctSelHi;
uint64 DramBaseLong, DramLimitLong;
uint64 DctSelBaseOffsetLong, ChannelOffsetLong,ChannelAddrLong;
// device is a user supplied value for the PCI device ID of the processor
// from which CSRs are initially read from (current processor is fastest).
// CH0SPARE_RANK and CH1SPARE_RANK are user supplied values, determined
// by BIOS during DIMM sizing.
CSFound = 0;
for(DramRange = 0; DramRange < 8; DramRange++)
{
F1Offset = 0x40 + (DramRange << 3);
DramBaseLow = Get_PCI(bus0, device, func1, F1Offset);
DramEn = DramBaseLow & 0x00000003;

IntlvEn = (DramBaseLow & 0x00000700) >> 8;
DramBaseLow = DramBaseLow & 0xFFFF0000;
DramBaseLong = ((Get_PCI(bus0, device, func1, F1Offset + 0x100))<<32 +
DramBaseLow)<<8;
DramLimitLow = Get_PCI(bus0, device, func1, F1Offset + 4);
NodeID = DramLimitLow & 0x00000007;
IntlvSel = (DramLimitLow & 0x00000700) >> 8;
DramLimitLow = DramLimitLow | 0x0000FFFF;
DramLimitLong = ((Get_PCI(bus0, device, func1, F1Offset + 0x104))<<32 +
DramLimitLow)<<8 | 0xFF;
HoleEn = Get_PCI(bus0, dev24 + NodeID, func1, 0xF0);
HoleOffset = (HoleEn & 0x0000FF80);
HoleEn = (HoleEn &0x00000003);
if(DramEn && DramBaseLong<=SystemAddr && SystemAddr <= DramLimitLong)
{
if(IntlvEn == 0 || IntlvSel == ((SystemAddr >> 12) & IntlvEn))
{
if(IntlvEn == 1) Ilog = 1;
else if(IntlvEn == 3) Ilog = 2;
else if(IntlvEn == 7) Ilog = 3;
else Ilog = 0;
Temp = Get_PCI(bus0, device, func2, 0x110);
DctSelHiRngEn = Temp & 1;
DctSelHi = Temp>>1 & 1;
DctSelIntLvEn = Temp & 4;
DctGangEn = Temp & 0x10;
DctSelIntLvAddr = (Temp>>6) & 3;
DctSelBaseAddr = Temp & 0xFFFFF800;
DctSelBaseOffsetLong = Get_PCI(bus0, device, func2, 0x114)<<16;
//Determine if High range is selected
if(DctSelHiRngEn && DctGangEn==0 && (SystemAddr>>27) >=
(DctSelBaseAddr>>11)) HiRangeSelected = 1;
else HiRangeSelected=0;
//Determine Channel
if(DctGangEn) ChannelSelect = 0;
else if (HiRangeSelected) ChannelSelect = DctSelHi;
else if (DctSelIntLvEn && DctSelIntLvAddr == 0)
ChannelSelect = SystemAddr>>6 & 1;
else if (DctSelIntLvEn && DctSelIntLvAddr>>1 & 1)
{
Temp = fUnaryXOR(SystemAddr>>16&0x1F); //function returns odd parity
//1= number of set bits in argument is odd.
//0= number of set bits in argument is even.
if(DctSelIntLvAddr & 1) ChannelSelect = (SystemAddr>>9 & 1)^Temp;
else ChannelSelect = (SystemAddr>>6 & 1)^Temp;
}
else if (DctSelIntLvEn && IntlvEn&4)ChannelSelect = SystemAddr>>15&1;
else if (DctSelIntLvEn && IntlvEn&2)ChannelSelect = SystemAddr>>14&1;
else if (DctSelIntLvEn && IntlvEn&1)ChannelSelect = SystemAddr>>13&1;
else if (DctSelIntLvEn) ChannelSelect = SystemAddr>>12&1;
else if (DctSelHiRngEn && DctGangEn==0) ChannelSelect = ~DctSelHi&1;
else ChannelSelect = 0;
//Determine Base address Offset to use
if(HiRangeSelected)
{
if(!(DctSelBaseAddr & 0xFFFF0000) && (HoleEn & 1) &&
(SystemAddr >= 0x1_00000000))
ChannelOffsetLong = HoleOffset<<16;
31116 Rev 3.06 - March 26, 2008 AMD Family 10h Processor BKDG
68
else
ChannelOffsetLong= DctSelBaseOffsetLong;
}
else
{
if((HoleEn & 1) && (SystemAddr >= 0x1_00000000))
ChannelOffsetLong = HoleOffset<<16;
else
ChannelOffsetLong = DramBaseLong & 0xFFFF_F8000000;
}
//Remove hoisting offset and normalize to DRAM bus addresses
ChannelAddrLong = SystemAddr & 0x0000FFFF_FFFFFFC0 -
ChannelOffsetLong & 0x0000FFFF_FF800000;
//Remove Node ID (in case of processor interleaving)
Temp = ChannelAddrLong & 0xFC0;
ChannelAddrLong = (ChannelAddrLong >>Ilog & 0xFFFF_FFFFF000)|Temp;
//Remove Channel interleave and hash
if(DctSelIntLvEn && DctSelHiRngEn==0 && DctGangEn==0)
{
if(DctSelIntLvAddr & 1 != 1)
ChannelAddrLong = (ChannelAddrLong>>1) & 0xFFFFFFFF_FFFFFFC0;
else if(DctSelIntLvAddr == 1)
{
Temp = ChannelAddrLong & 0xFC0;
ChannelAddrLong = ((ChannelAddrLong & 0xFFFFFFFF_FFFFE000) >> 1)| Temp;
}
else
{
Temp = ChannelAddrLong & 0x1C0;
ChannelAddrLong = ((ChannelAddrLong & 0xFFFFFFFF_FFFFFC00) >> 1)| Temp;
}
InputAddr = ChannelAddrLong>>8;
for(CS = 0; CS < 8; CS++)
{
F2Offset = 0x40 + (CS << 2);
if ((CS % 2) == 0)
F2MaskOffset = 0x60 + (CS << 1);
else
F2MaskOffset = 0x60 + ((CS-1) << 1);
if(ChannelSelect)
{
F2Offset+=0x100;
F2MaskOffset+=0x100;
}
CSBase = Get_PCI(bus0, dev24 + NodeID, func2, F2Offset);
CSEn = CSBase & 0x00000001;
CSBase = CSBase & 0x1FF83FE0;
CSMask = Get_PCI(bus0, dev24 + NodeID, func2, F2MaskOffset);
CSMask = (CSMask | 0x0007C01F) & 0x1FFFFFFF;
if(CSEn && ((InputAddr & ~CSMask) == (CSBase & ~CSMask)))
{
CSFound = 1;
OnlineSpareCTL = Get_PCI(bus0, dev24 + NodeID, func3, 0xB0);
if(ChannelSelect)
{
SwapDone = (OnlineSpareCTL >> 3) & 0x00000001;
BadDramCs = (OnlineSpareCTL >> 8) & 0x00000007;
if(SwapDone && CS == BadDramCs) CS=CH1SPARE_RANK;
}
else
31116 Rev 3.06 - March 26, 2008 AMD Family 10h Processor BKDG
69
{
SwapDone = (OnlineSpareCTL >> 1) & 0x00000001;
BadDramCs = (OnlineSpareCTL >> 4) & 0x00000007;
if(SwapDone && CS == BadDramCs) CS=CH0SPARE_RANK;
}
break;
}
}
}
}
if(CSFound) break;
} // for each DramRange
return(CSFound,NodeID,ChannelSelect,CS);


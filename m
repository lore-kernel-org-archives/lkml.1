Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbZIPQeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbZIPQeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbZIPQd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:33:59 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55005 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662AbZIPQd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w/9n9Ng2Gtx8hiRLdmvHhBIDEswm4gODJcgGAg5LZ5FiFDbLo4qORKOJpoGTbjiHzm
         TfRkpbCq7/EcvBpgusY/QugBPFIDafacHE0rrWwek2mpoFvbfANil/ZDOq56n1vh7tey
         QAlJX3N/mNH62VE22zWw0Cpsl84lbhRoHD4g0=
MIME-Version: 1.0
In-Reply-To: <20090916090907.2538fca1@jbarnes-g45>
References: <200909160910.24329.neuro@o2.pl>
	 <20090916090907.2538fca1@jbarnes-g45>
Date: Wed, 16 Sep 2009 12:33:58 -0400
Message-ID: <a728f9f90909160933sba29b49oee2020024866b7d0@mail.gmail.com>
Subject: Re: Explicitly putting a PCI device to ACPI D0
From: Alex Deucher <alexdeucher@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Michal Witkowski <neuro@o2.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 12:09 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 16 Sep 2009 09:10:24 +0200
> Michal Witkowski <neuro@o2.pl> wrote:
>
>> Hi,
>>
>> I've been searching for my answer for a while now, and since I
>> haven't found it anywhere, I've decided to post to LKML, hoping that
>> someone here can help me.
>>
>> First, I'll explain the background of my problem. My grief is the
>> switchable GPU in my Lenovo Ideapad U330. The BIOS supports two
>> options "Discrete only" (only the ATI card is visible on the BUS) and
>> "Switchable" (both ATI and Intel card visible on the bus). The
>> problem is the lack of a third option "Integrated", in which only the
>> Intel card would be powered off. Lenovo refused to introduce such an
>> option into the BIOS, stating that it's a feature request and not a
>> bug.
>>
>> To save battery power I'd like to be able to run on the Intel card.
>> However, with the "Switchable" option, powertop indicates huge power
>> usage (24W), which can only be explained by the fact that both cards
>> draw power.
>>
>> Thus, my question is the following:
>> Is there a way to explicitly put a device into ACPI D0? I would like
>> to do that to the ATI card on boot.
>>
>> I've tried the following code:
>> http://ftp.chg.ru/pub/parallel/scyld/diag/pci-config.c
>> But it didn't work (the ATI card was still on).
>
> Your best bet might be to load a driver for the ATI card that puts it
> into PCI D3 state until used.  There may be other ways to save power on
> the disabled part as well...
>
> Alex, is this something you've looked at at all?

The xf86-video-ati ddx can turn off the displays and reduce the clocks
and pcie lanes, but I haven't sorted out all the D3 stuff yet.  As for
the switchable graphics, you might find the page below useful.  No
idea if it will work or fry your hardware:
http://ubuntuforums.org/showthread.php?p=7944950

Alex

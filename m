Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbZLAFsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbZLAFsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZLAFsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:48:51 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:56390 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZLAFst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:48:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cJIlHuMncOYWovSTEDprvD6wVkiy5XHBBXlUQi9HabV5Ey2RrI1Ca/2Vh7SVnt0p0p
         5CsdeVqrqqSm4S2UWGKqQnPiIxmzxuP2cI0Mc5eoupJaI0He7TK/Tzo/Y/Px+y+oH4XW
         mpW2oL4tLptptMKLSJ7bNOv8WiQgrm036fp3Y=
MIME-Version: 1.0
In-Reply-To: <fa686aa40911300759h153b3300uc54b5d1871bfc839@mail.gmail.com>
References: <d1f76ba30911300038w272578dfx9adb116bde493e00@mail.gmail.com> 
	<d1f76ba30911300150g10c1382clb2958245ebf94362@mail.gmail.com> 
	<fa686aa40911300759h153b3300uc54b5d1871bfc839@mail.gmail.com>
From: Yogesh Chaudhari <mr.yogesh@gmail.com>
Date: Tue, 1 Dec 2009 11:18:36 +0530
Message-ID: <d1f76ba30911302148q60a9aea3s421f4d40081315f7@mail.gmail.com>
Subject: Re: Ethernet issues with lite5200 board from linux-2.6.31
To: Grant Likely <grant.likely@secretlab.ca>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grant,

2009/11/30 Grant Likely <grant.likely@secretlab.ca>:
> On Mon, Nov 30, 2009 at 2:50 AM, Yogesh Chaudhari <mr.yogesh@gmail.com> wrote:
>> Hello,
>>         I am running linux kernel with rt patch on embedded board
>> based on lite5200 eval board. From linux-2.6.31 release, in which the
>> mdio patch has gone inside,  the fec ethernet does not come up on this
>> board. I get the following message at startup:
>> mpc52xx MII bus: probed
>> mdio_bus f0003000: error probing PHY at address 1
>>
>>
>> After the bootup if I try to do a ifconfig I get the message:
>> net eth2: of_phy_connect failed
>>
>>
>> If I change the value of reg in dts file (lite5200.dts) to 0 then this
>> ethernet comes up. However upto this kernel version, this was not
>> required.
>>
>> Ethernet does not come up on board with original lite5200.dts file
>
> Is your board based on the Lite5200 or the Lite5200B?  The phys are at
> different addresses on those two revisions of the board.  There is a
> different .dts file for each board.
>
>> phy0: ethernet-phy@1 {
>>                                 reg = <1>;
>>                         };
>>
>> Ethernet comes up on board with this change
>> phy0: ethernet-phy@1 {
>>                                 reg = <0>;
>>                         };
>
> Some PHYs treat address 0 as the 'broadcast' address.  You need to
> fill in this field (and modify the ethernet-phy@<address> node name)
> to reflect the address that your phy is actually at.

This change in reg value was not required till 2.6.31. It is only
after this version that the change is needed. Is there some change in
31 that makes this change mandatory?

>
> g.
>



-- 
DREAM IT, CODE IT

"CODITO, ERGO SUM"
"I CODE, THEREFORE I AM"

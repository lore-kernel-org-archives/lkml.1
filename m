Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbZLCEOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbZLCEOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZLCEOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:14:22 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:59371 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbZLCEOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HO7j2aVYmSDshzz1xnWVTlywv4WBQcCzp5d3q/HSyHGXNhvFTrsAhiZlMSwseFOI59
         BZPgKBxCbTgMtxld30eR5lX2jnYYrAb9C1OPnjcQ6XxSHcpX5dbpCsVk8ggDD9KH86FO
         N2HEzJy2FafXKyV6NYvEYd971UNb8JyLBeZfI=
MIME-Version: 1.0
In-Reply-To: <fa686aa40911300759h153b3300uc54b5d1871bfc839@mail.gmail.com>
References: <d1f76ba30911300038w272578dfx9adb116bde493e00@mail.gmail.com> 
	<d1f76ba30911300150g10c1382clb2958245ebf94362@mail.gmail.com> 
	<fa686aa40911300759h153b3300uc54b5d1871bfc839@mail.gmail.com>
From: Yogesh Chaudhari <mr.yogesh@gmail.com>
Date: Thu, 3 Dec 2009 09:44:04 +0530
Message-ID: <d1f76ba30912022014y1f688827qe8145a7d40de5321@mail.gmail.com>
Subject: Re: Ethernet issues with lite5200 board from linux-2.6.31
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
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
>
> g.
>
 I have tried the same with the latest kernel both with and without
rt, but with the same end result. I have checked that the mpc52xx fec
driver was changed from 2.6.31 version but I am not able to point
where this error is coming up from and how changing the reg value in
dts (which is not required till previous versions) is solving this.

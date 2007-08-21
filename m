Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbXHUIHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbXHUIHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbXHUIGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:06:52 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:5879 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXHUIGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:06:50 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] =?iso-8859-1?q?R=E9f=2E_=3A_Re=3A_=5BPATCH_0/4=5D_Virtual_Machine_Time?=
 =?iso-8859-1?q?_Accounting?=
Date: Tue, 21 Aug 2007 10:06:42 +0200
User-Agent: KMail/1.9.7
Cc: "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "laurent.vivier@bull.net" <laurent.vivier@bull.net>,
       Jeremy Fitzhardinge <jeremy@goop.org>, John Stoffel <john@stoffel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
References: <OF945F7B1F.FF4B4672-ONC125733D.006266E7-C125733D.00626843@frec.bull.fr> <5d6222a80708201334q27fc6cbcr7ce6a9d7147437a2@mail.gmail.com>
In-Reply-To: <5d6222a80708201334q27fc6cbcr7ce6a9d7147437a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211006.42938.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. August 2007 schrieb Glauber de Oliveira Costa:
> Although I don't know KVM to a that deep level, I think it should be
> possible to keep the virtual cpus in different process (or threads),
> and take the accounting time from there. Perfectly possible to know
> the time we spent running (user time), and the time the hypervisor
> spent doing things on our behalf (system time).

I disagree here. First thing, you dont want to have the virtual cpu in a 
different process than the hypervisor control code for that cpu. Otherwise  
communication has to be made via IPC. 
Secondly, Its not qemu/kvm that does the accouting. Its existing userspace 
code like top/snmp agents and clients! etc. that would require additional 
knowledge which thread is guest code.

I personally like the approach Laurent has taken. Maybe it needs some polish 
and maybe we want an account_guest_time function, but in general I think he 
is doing the right thing. 

Christian

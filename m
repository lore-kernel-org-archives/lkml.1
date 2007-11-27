Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbXK0E4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbXK0E4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXK0E4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:56:31 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:46058 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXK0E4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:56:30 -0500
From: Konrad Rzeszutek <konrad@darnok.org>
To: Doug Maxey <dwm@enoyolf.org>
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Date: Mon, 26 Nov 2007 23:50:10 -0500
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, pjones@redhat.com,
       konradr@redhat.com, konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com,
       hpa@zytor.com, lenb@kernel.org, mike.anderson@us.ibm.com,
       dwm@austin.ibm.com
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <11870.1196136773@bebe.enoyolf.org>
In-Reply-To: <11870.1196136773@bebe.enoyolf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711262350.13100.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > sysfs files have ONE VALUE PER FILE, not a whole bunch of different
> > things in a single file.  Please fix this.
>
> The subparameters _are_ actually part of a single value, that value being
> associated with the initiator instance.
>
> Konrad is trying to implement a "work-alike" for what open firmware does.
> open-iscsi already has the ability to extract the same format
> bits from real OFW.
>
> See open-iscsi.git/utils/fwparam_ppc.


Greg,

In light of what Doug says (which is all true), should I go ahead with a new 
version of this module which would export one value per file? The problem 
that will be encountered is that a ethernetX sysfs directory would have (for 
example):

/sys/firmware/ibft/ethernet0/pci-bdf
5:1:0
/sys/firmware/ibft/ethernet0/mac
00:11:25:9d:8b:00
/sys/firmware/ibft/ethernet0/vlan
0
/sys/firmware/ibft/ethernet0/gateway
192.168.79.254
/sys/firmware/ibft/ethernet0/origin
0
/sys/firmware/ibft/ethernet0/subnet-mask
22
/sys/firmware/ibft/ethernet0/ip-addr
192.168.77.41
/sys/firmware/ibft/ethernet0/flags
7

And the flag would contain the value "7" which would mean the user would have 
to parse what each bit means? (the v0.3 of the module does not export this 
flag but uses it to figure out which is the boot iSCSI target).


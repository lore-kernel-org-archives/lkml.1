Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbZI2NHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbZI2NHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 09:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbZI2NHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 09:07:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZI2NHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 09:07:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2.6.31-rc9] net: VMware virtual Ethernet NIC driver: vmxnet3
Date: Tue, 29 Sep 2009 15:05:50 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Shreyas Bhatewara <sbhatewara@vmware.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
References: <89E2752CFA8EC044846EB849981913410173CDFAF6@EXCH-MBX-4.vmware.com> <20090929085333.GC3958@sequoia.sous-sol.org>
In-Reply-To: <20090929085333.GC3958@sequoia.sous-sol.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291505.50961.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18aXJ3WriIPRR0+HLdSXH9fmc1ZyTSCps3pE1N
 I6TBXrUcsGQ4Qk6/o8V3fKx0Opli8AdqsFBQPnaLUSFKwO8nSN
 s4x9dep4EG3o788+FqG4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 September 2009, Chris Wright wrote:
> > +struct Vmxnet3_MiscConf {
> > +       struct Vmxnet3_DriverInfo driverInfo;
> > +       uint64_t             uptFeatures;
> > +       uint64_t             ddPA;         /* driver data PA */
> > +       uint64_t             queueDescPA;  /* queue descriptor table PA */
> > +       uint32_t             ddLen;        /* driver data len */
> > +       uint32_t             queueDescLen; /* queue desc. table len in bytes */
> > +       uint32_t             mtu;
> > +       uint16_t             maxNumRxSG;
> > +       uint8_t              numTxQueues;
> > +       uint8_t              numRxQueues;
> > +       uint32_t             reserved[4];
> > +};
> 
> should this be packed (or others that are shared w/ device)?  i assume
> you've already done 32 vs 64 here

I would not mark it packed, because it already is well-defined on all
systems. You should add __packed only to the fields where you screwed
up, but not to structures that already work fine.

One thing that should possibly be fixed is the naming of identifiers, e.g.
's/Vmxnet3_MiscConf/vmxnet3_misc_conf/g', unless these header files are
shared with the host implementation.

	Arnd <><

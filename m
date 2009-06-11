Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbZFKC2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbZFKC2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZFKC2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:28:43 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:58174 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZFKC2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:28:42 -0400
To: subrata@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
       Li Yang <leoli@freescale.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Re:[BUILD FAILURE 04/04] Next June 04:PPC64 randconfig
 [drivers/net/ucc_geth.o]
References: <20090610174323.28045.70169.sendpatchset@subratamodak.linux.ibm.com>
 <20090611110523.1fd56a41.sfr@canb.auug.org.au>
 <1244685364.6494.14.camel@subratamodak.linux.ibm.com>
From: Nathan Lynch <ntl@pobox.com>
Date: Wed, 10 Jun 2009 21:28:30 -0500
In-Reply-To: <1244685364.6494.14.camel@subratamodak.linux.ibm.com> (Subrata
 Modak's message of "Thu\, 11 Jun 2009 07\:26\:04 +0530")
Message-ID: <m3d49btsfl.fsf@pobox.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: 95B0F22A-562F-11DE-8372-97731A10BFE7-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak <subrata@linux.vnet.ibm.com> writes:

> On Thu, 2009-06-11 at 11:05 +1000, Stephen Rothwell wrote:
>> Hi Subrata,
>> 
>> On Wed, 10 Jun 2009 23:13:23 +0530 Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
>> >
>> >  	/* Find the TBI PHY.  If it's not there, we don't support SGMII */
>> > -	ph = of_get_property(np, "tbi-handle", NULL);
>> > +	ph = (phandle *)of_get_property(np, "tbi-handle", NULL);
>> 
>> You don't need this cast because of_get_property() returns "void *".
>
> Stephen,
>
> True. But without this gcc complains:
>
> CC [M]  drivers/net/ucc_geth.o
> drivers/net/ucc_geth.c: In function ‘ucc_geth_probe’:
> drivers/net/ucc_geth.c:3824: warning: assignment discards qualifiers
> from pointer target type

ph should be declared const phandle *.  Look at other uses of
of_get_property.


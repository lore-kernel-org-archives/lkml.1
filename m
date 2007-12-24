Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXLXJLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXLXJLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 04:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbXLXJKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 04:10:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.112.152]:17896 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXLXJKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 04:10:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Mon, 24 Dec 2007 01:10:53 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Date: Mon, 24 Dec 2007 17:10:29 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1F571D0F@hkemmail01.nvidia.com>
In-Reply-To: <m1d4t17zkn.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Thread-Index: AchDWn36UZ6hc0CJSQ6pUCyKDzkdDwCsZz3w
References: <200712182300373901202@gmail.com><m14pefaclv.fsf@ebiederm.dsl.xmission.com><15F501D1A78BD343BE8F4D8DB854566B1F24C119@hkemmail01.nvidia.com> <m1d4t17zkn.fsf@ebiederm.dsl.xmission.com>
From: "Peer Chen" <pchen@nvidia.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "peerchen" <peerchen@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Andy Currid" <ACurrid@nvidia.com>
X-OriginalArrivalTime: 24 Dec 2007 09:10:30.0954 (UTC) FILETIME=[D52458A0:01C8460C]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I feel it's dangerous to set the En bit on Intel platform, If the HT MSI
En is set, the MSI should be expected to transform to HT INT message
format. It may cause interrupt lost or hardware internal state machine
failed depend on the hardware design.

BRs
Peer Chen

-----Original Message-----
From: Eric W. Biederman [mailto:ebiederm@xmission.com] 
Sent: Friday, December 21, 2007 6:48 AM
To: Peer Chen
Cc: peerchen; linux-kernel; akpm; Andy Currid
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability

"Peer Chen" <pchen@nvidia.com> writes:

> The quirk is for our Intel platform, we don't want HT MSI mapping
> enabled in any of our devices.

Why is this a problem?  I seem to recall a real hypertransport bus
downstream of the Intel cpu.

If there is a real hypertransport bus in the middle then what happens
if someone puts a tunnel that uses hypertransport between the two chips?

I feel very dense right now.  I don't understand why enabling the
mapping on an Intel based system is a problem.  I am afraid there is
some important gap in my understanding in which case we may need to
rethink enabling the hypertransport capability by default.

If disabling the hypertransport bus is simply an optimization, or it
is to deal with an issue that appears exclusive to Nvidia chips
I have no problem with your quirk.

Eric
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------

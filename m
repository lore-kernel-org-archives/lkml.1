Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYABRgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYABRgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYABRfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:35:55 -0500
Received: from hqemgate04.nvidia.com ([216.228.112.152]:16829 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYABRfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:35:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Wed, 02 Jan 2008 09:35:44 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: sata_nv + ADMA + Samsung disk problem
Date: Wed, 2 Jan 2008 09:23:29 -0800
Message-ID: <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com>
In-Reply-To: <477B0CFD.1030603@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sata_nv + ADMA + Samsung disk problem
Thread-Index: AchM9GiIdZy8ZfBlQnWUdJGjzhp8uQAb386A
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca>
From: "Allen Martin" <AMartin@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>, "Tejun Heo" <htejun@gmail.com>
Cc: "Gabor Gombas" <gombasg@sztaki.hu>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>, "Kuan Luo" <kluo@nvidia.com>,
       "Peer Chen" <pchen@nvidia.com>
X-OriginalArrivalTime: 02 Jan 2008 17:23:29.0959 (UTC) FILETIME=[31521370:01C84D64]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The question I had for NVIDIA regarding this that I never got 
> answered 
> was, is there any reason why we would need a delay when switching 
> between NCQ and non-NCQ commands on ADMA, and if not, is 
> there any known 
> cause that could cause the controller to get into this seemingly 
> locked-up state?

When switching from NCQ to non NCQ or vice versa you must make sure all
outstanding commands are completed before issuing the new command.  The
hardware doesn't do anything to prevent queued and non queued commands
from going out on the wire at the same time which will certainly cause
some drives to fail.

-Allen
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------

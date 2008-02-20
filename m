Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYBTRs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYBTRs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYBTRst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:48:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbYBTRss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:48:48 -0500
Message-ID: <47BC67CE.9070407@redhat.com>
Date: Wed, 20 Feb 2008 18:47:58 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com> <47BC0DA9.1030607@redhat.com> <20080220172449.GD27726@gondor.apana.org.au>
In-Reply-To: <20080220172449.GD27726@gondor.apana.org.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Wed, Feb 20, 2008 at 12:23:21PM +0100, Milan Broz wrote:
>> It seems that some module dependency was lost, 
>> dm-crypt with async crypto depends now on crypto_blkcipher module
>> for this configuration.
>>
>> Herbert, any following change required for dm-crypt or it is only
>> crypto subsystem issue?
>> (With old kernel/dm-crypt it loads "blkcipher" not "crypto_blkcipher",
>> maybe some initramdisk change required too...)
> 
> Right blkcipher was renamed to crypto_blkcipher due to the merge
> of blkcipher/ablkcipher.  If this is causing a problem with the
> initramfs then we need to fix the initramfs tools to look at the
> actual dependencies rather than hard-coding it.

I just tested one affected configuration and problem was in missing
"chainiv.ko" module on ramdisk.

Milan
--
mbroz@redhat.com


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbYFBMcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbYFBMcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYFBMcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:32:08 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:6861 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYFBMcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ee+hVD70jEk8O178O3GasxW8TXRcRC0RgWSMCzRYZah8XYf4eaYFQGkzPshboxRmusPNhd80Xgc0SdS23di1k9whCyrek3d7WZefhopFFPRKh5TX5dsv6+eRk03l6Tqx4Ch1lKNcsbFS1wfUVVSziIHREFtNDLKmVDPY8GfuLZI=
Date: Mon, 2 Jun 2008 20:31:45 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Yan Li <elliot.li.tech@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ritesh Raj Sarraf <rrs@researchut.com>,
       Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
       rjmaomao@gmail.com, Alasdair G Kergon <agk@redhat.com>,
       dm-crypt@saout.de
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Message-ID: <20080602123145.GA8258@yantp.cn.ibm.com>
References: <20080602030738.GA7761@yantp.cn.ibm.com> <48439890.6030904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48439890.6030904@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milan,

On Mon, Jun 02, 2008 at 08:52:00AM +0200, Milan Broz wrote:
> Please could you try if  patch here helps and doesn't cause performance degradation?
> http://www2.kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.25/dm-crypt-add-cond_resched.patch

Will the result of testing a Debian 2.6.24-etchnhalf.1-amd64 kernel
(very near a vanilla kernel) be of same value?  Since the data on some
other drives on this server is important so I dare not try 2.6.25-rc
on it.

Following is my test plan, comments are welcomed:

Test command:
# dd if=/dev/zero of=/dev/mapper/open_device bs=500M count=10
(this server has 2G memory)

The command will be run	for 3 times, and average speed of last two
runs will be taken as result score.

Dm-crypt LUKS Encryption scenarios:
aes-cbc-essiv:sha256, keysize 128
aes-xts-plain, keysize 256
aes-xts-plain, keysize 512

I will compare the speed of all above 3 encryption scenarios, with and
without the patch.

--
Li, Yan

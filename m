Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYISWIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYISWIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYISWH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:07:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:43986 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYISWH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tNSqW32REeZ3uUaAfkrehy1r32s0rMrbhbMdJmm3SmV4wSjrJvL121ZipT03/jcB06
         R1+LFDiQi1kyYuLg7ViRLpmGB/sjcaXPDtJd/oza1Xk4qW4F6Q9z6248U1KNAE3JkluU
         Xp+Cnl3vTFxP2h8K0BffCzFSkGNQUeg9gZQT0=
Message-ID: <84144f020809191507w64ff1c47m40c2c500da3fdfa6@mail.gmail.com>
Date: Sat, 20 Sep 2008 01:07:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [patch 3/3] Increase default reserve percpu area
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
In-Reply-To: <84144f020809191502i35805980n97dc3073ab8a52bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919203703.312007962@quilx.com>
	 <20080919203724.474751340@quilx.com>
	 <84144f020809191502i35805980n97dc3073ab8a52bc@mail.gmail.com>
X-Google-Sender-Auth: eec10f270d661d22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 1:02 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Fri, Sep 19, 2008 at 11:37 PM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
>> SLUB now requires a portion of the per cpu reserve. There are on average
>> about 70 real slabs on a system (aliases do not count) and each needs 12 bytes
>> of per cpu space. Thats 840 bytes. In debug mode all slabs will be real slabs
>> which will make us end up with 150 -> 1800. Give it some slack and add 2000
>> bytes to the default size.
>>
>> Things work fine without this patch but then slub will reduce the percpu reserve
>> for modules.
>
> Hmm, shouldn't this be dynamically configured at runtime by
> multiplying the number of possible CPUs with some constant?

Oh, never mind, setup_per_cpu_areas() already does that, obviously.

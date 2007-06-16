Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbXFPEk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbXFPEk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 00:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbXFPEkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 00:40:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:29396 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbXFPEkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 00:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RWSG/aSGiogtMrtWs5v5HpkbEa86YQ6I3Fy7ajLoHR+BAFvHXPwWhKYYrLxk+T8MbZkBaR54KFeg8+QS5t8CH0QRPtsa/X2luql+WNv0rySQFsF6KvuSgowtiHAPZ36NgPXAEdt+yzAEM+OaKq1ujHYLH6A9qvBSEn+/3SOq0og=
Message-ID: <a56dfcf00706152140s36d01ff6sb9a6bb716b8afe65@mail.gmail.com>
Date: Sat, 16 Jun 2007 00:40:17 -0400
From: "Dan Merillat" <dan.merillat@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: limits on raid
Cc: "Wakko Warner" <wakko@animx.eu.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <18035.23867.576212.859440@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	 <18034.479.256870.600360@notabene.brown>
	 <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	 <18034.3676.477575.490448@notabene.brown>
	 <20070616020320.GB2002@animx.eu.org>
	 <18035.23867.576212.859440@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> For raid5 on an array with more than 3 drive, if you attempt to write
> a single block, it will:
>
>  - read the current value of the block, and the parity block.
>  - "subtract" the old value of the block from the parity, and "add"
>    the new value.
>  - write out the new data and the new parity.
>
> If the parity was wrong before, it will still be wrong.  If you then
> lose a drive, you lose your data.

Wow, that really needs to be put somewhere in 120 point red blinking
text.  A lot of us are used to uninitialized disks calculating the
parity-on-first-write, but if linux MD is forgoeing that
'dangerous-no-resync' sounds really REALLY bad.  How about at least a
'Warning: unlike other systems this WILL cause corruption if you
forego reconstruction' on mkraid?

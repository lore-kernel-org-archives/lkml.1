Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbYIVHAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbYIVHAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 03:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYIVG7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 02:59:54 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:33719 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYIVG7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 02:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tXM83yKztsd5HJQXiDVwNFHSc16Kqz23gJhwEkjDxxfUfOiL6TMJkkdBVgQQ2trPdu
         7Ty/H6sdAE6otoW2zM5JW2lCmCWv2rrkBBnh4MNJj1axomI2IgX+ckZQSZ9zwOrfAWkr
         +hhW5GV0MXeWcsOt2qeFU3aTjWOcBhjLhB8Ps=
Message-ID: <21d7e9970809212359y6876c405ub57dca3e9ee737e4@mail.gmail.com>
Date: Mon, 22 Sep 2008 16:59:51 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, david.vrabel@csr.com
In-Reply-To: <20080921.165159.67476441.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
	 <7lIhZC4hCxE.A.yj.E2q1IB@albercik>
	 <20080921.165159.67476441.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 9:51 AM, David Miller <davem@davemloft.net> wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sun, 21 Sep 2008 20:54:13 +0200 (CEST)
>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=11382
>> Subject               : e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
>> Submitter     : David Vrabel <david.vrabel@csr.com>
>> Date          : 2008-08-08 10:47 (45 days old)
>> References    : http://marc.info/?l=linux-kernel&m=121819267211679&w=4
>> Handled-By    : Christopher Li <chrisl@vmware.com>
>
> Fixed by:
>
> commit 78566fecbb12a7616ae9a88b2ffbc8062c4a89e3
> Author: Christopher Li <chrisl@vmware.com>
> Date:   Fri Sep 5 14:04:05 2008 -0700
>
>    e1000: prevent corruption of EEPROM/NVM
>
>    Andrey reports e1000 corruption, and that a patch in vmware's ESX fixed
>    it.
>
>    The EEPROM corruption is triggered by concurrent access of the EEPROM
>    read/write. Putting a lock around it solve the problem.
>

Just noticed I replied to davem and not to everyone.. so I did some
further hunting.

Okay so e1000e seems to have a problem in this area, that this *DOESN'T* fix.

I've reconstructed my boot timeline from message logs

Sep 3rd, I booted rawhide kernel 2.6.27-0.290.rc5.fc10.i686

I suspended/resume a few times in between with no issues.

Sep 8th I booted my own 2.6.27-rc5 kernel based from
ec0c15afb41fd9ad45b53468b60db50170e22346

This got a corrupted e1000e checksum and every kernel since has.

Dave.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYIBXIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYIBXIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYIBXID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:08:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:58993 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYIBXIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ac0Asn5mErhgp7BATm53DLk06Akp6f1WoC4EEIdx98bXRlAkq4uH5Qs8BvTwxyuYt9
         pojcu5y/V3vOLEp2taKFEst1wzBta6I5bbApHGMzLxoxNOSfVpAzhwPK7i5aJRCYtCni
         hA8jivRel0tj7Yaki31VbkiJduf9ODqOq6teM=
Message-ID: <86802c440809021608s54725294t5629255bb1f0c9@mail.gmail.com>
Date: Tue, 2 Sep 2008 16:08:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] /proc/mtrr I/O error
Cc: "Bob Tracy" <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080902154620.314ad5c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080829213824.GA2281@gherkin.frus.com>
	 <20080902154620.314ad5c2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2008 at 3:46 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 29 Aug 2008 16:38:24 -0500
> Bob Tracy <rct@gherkin.frus.com> wrote:
>
>> With 2.6.27-rc4 and possibly earlier kernels, I see the following:
>>
>> $ cat /proc/mtrr
>> cat: /proc/mtrr: Input/output error
>>
>> Processor is an AMD K6-III/450.
>>
>
> static int mtrr_open(struct inode *inode, struct file *file)
> {
>        if (!mtrr_if)
>                return -EIO;
>
>
>
> Beats me.  Perhaps something broke in mtrr_bp_init().
>
> It would be useful to know if 2.6.26 worked OK.
>

two patches needed..

http://lkml.org/lkml/2008/9/1/307
   [PATCH 4/6] x86: delay early cpu initialization until cpuid is done
http://lkml.org/lkml/2008/9/1/308
  [PATCH 5/6] x86: move mtrr cpu cap setting early in early_init_xxxx

YH

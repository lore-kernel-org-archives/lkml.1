Return-Path: <linux-kernel-owner+w=401wt.eu-S935582AbYETPi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582AbYETPi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935218AbYETPgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:36:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:37996 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935216AbYETPgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U9y4AdCM94nz1L6V1Dbws1uSlbQHmd+/JUlXZyhNA4Sa+U8yIvi+xB+G4QviscqdBk8vEFDXwj25uM0FXviUVgk/+EsnHl/eNO7rZNs/JbX8VZpEdoaA53dWKqIRbyJ5PPrdW56v+ugPPxZwrzVkBlkMoEFNMacUw95ZBeMm1tQ=
Message-ID: <7b9198260805200836q6b9ad5f0x3b42c8f6c933fa21@mail.gmail.com>
Date: Tue, 20 May 2008 16:36:50 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080520153456.GN2638@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211196126-7442-1-git-send-email-tspink@gmail.com>
	 <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>
	 <20080520134306.GA28946@ZenIV.linux.org.uk>
	 <20080520135732.GA30349@infradead.org>
	 <7b9198260805200818v687fc495nb7db5ffd6c8b6ba1@mail.gmail.com>
	 <20080520153456.GN2638@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Matthew Wilcox <matthew@wil.cx>:
> On Tue, May 20, 2008 at 04:18:14PM +0100, Tom Spink wrote:
>> +
>> +     mutex_lock(&type->fs_supers_lock);
>> +     if (list_empty(&type->fs_supers) && type->init) {
>> +             err = type->init();
>> +             if (err) {
>> +                     mutex_unlock(&type->fs_supers_lock);
>> +                     spin_unlock(&sb_lock);
>> +                     destroy_super(s);
>> +                     return ERR_PTR(err);
>> +             }
>> +     }
>> +
>> +     list_add(&s->s_instances, &type->fs_supers);
>> +     mutex_unlock(&type->fs_supers_lock);
>> +
>>       s->s_type = type;
>>       strlcpy(s->s_id, type->name, sizeof(s->s_id));
>>       list_add_tail(&s->s_list, &super_blocks);
>> -     list_add(&s->s_instances, &type->fs_supers);
>> +
>>       spin_unlock(&sb_lock);
>
> You can't take a mutex while holding a spinlock -- what if you had to
> sleep to acquire the mutex?
>
> I imagine you also don't want to hold a spinlock while calling the
> ->init or ->exit -- what if the fs wants to sleep in there (eg allocate
> memory with GFP_KERNEL).
>
> --
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>

Oh no!  This is bad.  I really need to devise some script to stress
test my code - and also make myself pay attention to what I'm doing.
Sorry for the noise, guys.

-- 
Tom Spink

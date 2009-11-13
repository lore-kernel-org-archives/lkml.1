Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZKMAbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZKMAbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 19:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZKMAbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 19:31:41 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:60023 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbZKMAbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 19:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lfgu0AlBNJqDi7wcygIHa3s1BdW+GQzf8xGxqmgr/wKYSPZx9kvT2MWBkuYRa3kZZx
         gV3Cqoxli49JJWdsVc0iy/nS5BoClFCFFNkW/PiQbiFZ3ZATFH2ilPycCBfPYEvPZAkC
         m74jS3DJv8P6+3MGGbgKUt0gsSvyLgNRtsf2I=
MIME-Version: 1.0
In-Reply-To: <9b2b86520911121531y70e05d4rcd361ec33799bc0a@mail.gmail.com>
References: <1258067006-2205-1-git-send-email-lrodriguez@atheros.com> 
	<9b2b86520911121531y70e05d4rcd361ec33799bc0a@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 12 Nov 2009 16:31:26 -0800
X-Google-Sender-Auth: 48c6f62f9634f0cf
Message-ID: <43e72e890911121631q2e4afd17k59dfb30bc1d309f2@mail.gmail.com>
Subject: Re: [RFC] scripts: add gen-linux-conf for remote kernel configuration
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, greg@kroah.com,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 3:31 PM, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> On 11/12/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
>> The new 'make localmodconfig' proves very useful but on low end
>> systems we do not want to 'git clone' an entire kernel tree or
>> download a whole kernel but just cross compile the kernel on a
>> bigger machine. The .config generated with 'make localmodconfig'
>> is still very helpfup though so to aid users and developers
>> with that add a script which builds a tarball with only the
>> necessary kernel glue stuff to be able to generate a local
>> minimum kernel configuration with 'make localmodconfig'.
>>
>> With this you can copy to your target device a relatively
>> small tarball (1.2 MB currenty) and, allows you to modify
>> the kernel config for your tree (mconf, conf, etc) and
>> finally run 'make localmodconfig'.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>
>> I had an itch to scratch and that was to use 'localmodconfig'
>> on a small netbook but I didn't want to clone a whole tree
>> or even compile an entire kernel on it. This did the trick,
>> thought others might find it useful.
>>
>> A little grimy the bash script, but hey it works and its simple
>> enough. I tried to reduce the Makefile count to only arch/ but
>> found that that didn't do the trick. Perhaps this can be optimized
>> more, suggestions welcomed. Maybe it should be written in Go :)
>>
>> What would be *real* nice is to give an IP address of a box and
>> have it build and fetch a localmodconfig .config for you.
>>
>>   Luis
>
> Thanks for posting this.
>
> When I tried this for my netbook, my approach was to copy
> /proc/modules and /boot/config from the netbook.  As a shameless hack,
> I temporarily bind mounted /proc/modules on the build system.  I guess
> the cleaner way would be to copy the result of "lsmod", and have
> localmodconfig accept "LSMOD_FILE=file".
>
> Naturally I think my approach is simpler, despite not having actually
> implemented it properly :).  What do you think about it?

It does sound simpler, but you'd still need the netbook's config and
upgrade it to the the desired kernel's config, so you'd need to
address that too. Just lsmod won't cut it I think.

  Luis

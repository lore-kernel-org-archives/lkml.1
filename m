Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZKZTDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZKZTDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZKZTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:03:45 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:46981 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZKZTDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:03:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=e1uC1cnVOTJMpYJkeD0NeXsplduT8MUQKyomvLne4M0MT0FxuW/Lf7+yjdJb7cODkg
         KmwVH6TnkuhgJuEskJIfz4gRTMNmjsq2RFHJwDAq32aeMMswwZmy08Pj2ijvI5i9fMbh
         /AR+fwXab5P211SRedvxFqU4mkG6gdIA3jskE=
MIME-Version: 1.0
In-Reply-To: <4B0E634B.8070506@suse.cz>
References: <1259124522-26050-1-git-send-email-vapier@gentoo.org> 
	<4B0E634B.8070506@suse.cz>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 26 Nov 2009 14:03:31 -0500
Message-ID: <8bd0f97a0911261103w499540e1p24d9cb219808c0b9@mail.gmail.com>
Subject: Re: [PATCH] kconfig: display an error message when aborting
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/26 Michal Marek
> On 25.11.2009 05:48, Mike Frysinger wrote:
>> If the Kconfig option causes an open() failure (like one that starts with
>> an underscore), there should be an error message shown since we're going
>> to be exiting with an error code.  Otherwise, the reason for the failure
>> can really only be diagnosed with strace or something similar.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>>  scripts/kconfig/confdata.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
>> index b55e72f..e2644b4 100644
>> --- a/scripts/kconfig/confdata.c
>> +++ b/scripts/kconfig/confdata.c
>> @@ -640,6 +640,8 @@ static int conf_split_config(void)
>>               fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
>>               if (fd == -1) {
>>                       if (errno != ENOENT) {
>> +                             conf_warning("sym '%s' with path '%s': %s",
>> +                                          sym->name, path, strerror(errno));
>>                               res = 1;
>>                               break;
>>                       }
>
> I agree that there definitely needs to be some error reporting (and not
> only here but in many more places, look e.g. at conf_write() or
> conf_write_autoconf()), but why use conf_warning() for this? It will
> prefix the error message with "include/config/auto.conf:<last lineno>",
> which has nothing to do with the path that could not be opened.

no it doesnt.  it prefixes the config file name which i think is relevant.
    .config:1871:warning: sym '_BF548' with path '/bf548.h': Permission denied
-mike

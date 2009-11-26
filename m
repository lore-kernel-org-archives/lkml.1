Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbZKZUYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbZKZUYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 15:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZKZUYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 15:24:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:59547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZKZUYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 15:24:44 -0500
Message-ID: <4B0EE411.4000907@suse.cz>
Date: Thu, 26 Nov 2009 21:24:49 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: display an error message when aborting
References: <1259124522-26050-1-git-send-email-vapier@gentoo.org> 	<4B0E634B.8070506@suse.cz> <8bd0f97a0911261103w499540e1p24d9cb219808c0b9@mail.gmail.com> 	<4B0EDFF4.2030909@suse.cz> <8bd0f97a0911261212q3b9cf6cm71235c6cf7fae40f@mail.gmail.com>
In-Reply-To: <8bd0f97a0911261212q3b9cf6cm71235c6cf7fae40f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger napsal(a):
> On Thu, Nov 26, 2009 at 15:07, Michal Marek wrote:
>> Mike Frysinger napsal(a):
>>> 2009/11/26 Michal Marek
>>>> On 25.11.2009 05:48, Mike Frysinger wrote:
>>>>> If the Kconfig option causes an open() failure (like one that starts with
>>>>> an underscore), there should be an error message shown since we're going
>>>>> to be exiting with an error code.  Otherwise, the reason for the failure
>>>>> can really only be diagnosed with strace or something similar.
>>>>>
>>>>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>>>>> ---
>>>>>  scripts/kconfig/confdata.c |    2 ++
>>>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
>>>>> index b55e72f..e2644b4 100644
>>>>> --- a/scripts/kconfig/confdata.c
>>>>> +++ b/scripts/kconfig/confdata.c
>>>>> @@ -640,6 +640,8 @@ static int conf_split_config(void)
>>>>>               fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
>>>>>               if (fd == -1) {
>>>>>                       if (errno != ENOENT) {
>>>>> +                             conf_warning("sym '%s' with path '%s': %s",
>>>>> +                                          sym->name, path, strerror(errno));
>>>>>                               res = 1;
>>>>>                               break;
>>>>>                       }
>>>> I agree that there definitely needs to be some error reporting (and not
>>>> only here but in many more places, look e.g. at conf_write() or
>>>> conf_write_autoconf()), but why use conf_warning() for this? It will
>>>> prefix the error message with "include/config/auto.conf:<last lineno>",
>>>> which has nothing to do with the path that could not be opened.
>>> no it doesnt.  it prefixes the config file name which i think is relevant.
>>>     .config:1871:warning: sym '_BF548' with path '/bf548.h': Permission denied
>> Well, it prints either ".config" or "include/config/auto.conf",
>> depending whether there was a successful silentoldconfig pass before and
>> the latter file exists. But the number is the number of lines of the
>> respective file.
> 
> if you want to improve kconfig's error reporing in general, have at
> it,

I'll write something if time permits.

> but conf_warning() appears to be the standard in confdata.c for
> reporting errors/warnings to stderr.  your complaint applies to just
> about every usage of conf_warning() in confdata.c.  i'm not going to
> create my own format and fprintf() directly to stderr.

No. conf_warning() does the right thing when called from within
conf_read_simple(), which maintains the conf_filename and conf_lineno
variables. That's the point I was trying to make.

Michal

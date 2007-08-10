Return-Path: <linux-kernel-owner+w=401wt.eu-S936500AbXHJNZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936500AbXHJNZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbXHJNY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:24:58 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:7515 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbXHJNY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:24:58 -0400
Message-ID: <46BC666F.6010409@openvz.org>
Date: Fri, 10 Aug 2007 17:21:51 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, devel@openvz.org
Subject: Re: [PATCH] Fix OOPS in show_uevent()
References: <46BC3A57.5070404@openvz.org>	<3ae72650708100523w45b4d5cbxf0ffbdc11cfb5e45@mail.gmail.com> <20070810143927.619d0640@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070810143927.619d0640@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Fri, 10 Aug 2007 14:23:56 +0200,
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> 
>> But we still don't update the remaining buffer size and the remaining
>> array fields which are left after the call. Shouldn't we instead just
>> change the:
>>    int (*dev_uevent)(struct device *dev,
>>                                 char **envp, int num_envp,
>>                                 char *buffer, int buffer_size);
>> to:
>>   int (*dev_uevent)(struct device *dev,
>>                                char **envp, int num_envp, int *cur_index,
>>                                char *buffer, int buffer_size, int *cur_len);
>>
>> like we do for:
>>   int add_uevent_var(char **envp, int num_envp, int *cur_index,
>>                                   char *buffer, int buffer_size, int *cur_len,
>>                                   const char *format, ...)
>>
>> and along with the change of the callers, we would update the values
>> properly, so the next call has the correct numbers? There are 6
>> classes and something like 12 buses using this method, so it shouldn't
>> be too much trouble.

isn't it better to change
    int (*dev_uevent)(struct device *dev,
                                 char **envp, int num_envp,
                                 char *buffer, int buffer_size);
to
    int (*dev_uevent)(struct device *dev,
                                 char **envp, int num_envp,
                                 char **buffer);
and alter the buffer pointer inside?


> Sounds like a sensible approach. We may want the remaining non-users to
> add_uevent_var() at the same time, I guess.
> 

Thanks,
Pavel

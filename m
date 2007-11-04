Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbXKDWUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbXKDWUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 17:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXKDWUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 17:20:01 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:39223 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXKDWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 17:20:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Is7Y8MU1DBDc07hCrrvnsgKVHNHO55VBNIlyhNmugWosRgeQEPUJ1+6kviCY31usPwKqs7NCr9ZGfE75HB7LTIhjDn7SzrX85Pkiw3bcBADzHzaZj5fAwug1QNm6l5+EkB7WMRluFhQLBBRITGgBMcyJVw60P5ma0V2X7eNj31s=
Message-ID: <472E458B.50903@gmail.com>
Date: Sun, 04 Nov 2007 23:19:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Felipe Dias <felipediassss@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: textsearch in module = BUG: scheduling while atomic
References: <3c16e8dc0711040915n206c38d6u7e15972bf55e0e0d@mail.gmail.com>	 <472E07ED.2010907@gmail.com>	 <3c16e8dc0711041222w6bc67b3fn8320e982ffd723b0@mail.gmail.com>	 <472E346E.90309@gmail.com> <3c16e8dc0711041405m33c5e54dw6c8d51ac600d51cf@mail.gmail.com> <472E44CA.6090600@gmail.com>
In-Reply-To: <472E44CA.6090600@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2007 11:16 PM, Jiri Slaby wrote:
> On 11/04/2007 11:05 PM, Felipe Dias wrote:
>> Ow sorry... the warning:
>>
>> BUG: scheduling while atomic: gnome-cups-icon/0x00000101/3827
>>  [<c02aefe6>] __sched_text_start+0x56/0x7c8
>>  [<c0130139>] autoremove_wake_function+0x14/0x33
>>  [<c0119284>] __wake_up_common+0x35/0x53
>>  [<c01197f6>] __wake_up+0x32/0x43
>>  [<c02af847>] wait_for_completion+0x6a/0x9f
>>  [<c011b6ae>] default_wake_function+0x0/0xc
>>  [<c012cdff>] call_usermodehelper_keys+0xad/0xc5
>>  [<c012ceec>] request_module+0xd5/0xe6
> 
> Seems like it is not inteded for using in atomic at all (you probably passed an
> unknown algo here to the prepare function). You seem to have to use a workqueue
> if it is possible or prepare the serach before the interrupt occurs.

Or pass 0 instead of TS_AUTOLOAD.

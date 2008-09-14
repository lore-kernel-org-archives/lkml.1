Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYINQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYINQES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYINQEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 12:04:10 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:54427 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYINQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 12:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PLtiA59dqVdYbfxfDIWPO5Fo3uHvlwsZr4/DzQowzomm3E4Lf0lMAcCXOebCz42NDy
         yVzAmW9tWh5ABVdADWW6KZyZQGIXPYjyVMLIDDQYfVDVgThIoBMK2MlF/vkbqieb5Ynm
         PhOieEQfZF+9Gd/f0OYF80vOXJ2aWg7xKHvA4=
Message-ID: <a36005b50809140904h690d00b0sa66f166a64850114@mail.gmail.com>
Date: Sun, 14 Sep 2008 09:04:08 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task struct
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
In-Reply-To: <20080914155744.GA4845@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080901160343.75a89ec9@infradead.org>
	 <20080901161423.59ebf2fc@infradead.org>
	 <20080902100439.GA11383@elf.ucw.cz>
	 <20080902060323.70245b83@infradead.org>
	 <20080908132713.GA18486@elf.ucw.cz>
	 <20080908064002.7abc2a22@infradead.org>
	 <20080908141555.GB31784@elf.ucw.cz>
	 <a36005b50809140821w2caeb810p431cf5625b0297f5@mail.gmail.com>
	 <20080914155744.GA4845@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 8:57 AM, Pavel Machek <pavel@suse.cz> wrote:
>> LD_PRELOAD and other variables are ignored in security-relevant
>> contexts and environments are cleared in many situations.  Sure, you
>
> ...but that's okay, right? You would not want passwd to inherit huge
> slack specified by attacker...?

No, it's not OK.  There are enough apps which are privileged and need
to be handled this way.  Take the X server, for instance.

]
> Well, it is not too much, but... is the cost for userspace really
> significant? You'd clearly want it stored in environment, not
> filesystem...

You cannot really use the environment for anything meaningful.
Especially for this case, you couldn't change the setting for a
running process.  What a fully-userlevel implementation would have to
do is read the value from a file and monitor the file for changes for
every new poll/select call.  That's a huge cost.

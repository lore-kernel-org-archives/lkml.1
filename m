Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZI0P4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZI0P4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 11:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZI0P4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 11:56:35 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:59318 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZI0P4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 11:56:34 -0400
Message-ID: <4ABF8B30.5050801@cesarb.net>
Date: Sun, 27 Sep 2009 12:56:32 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] WARN_ONCE(): use bool for boolean flag
References: <1254059590-31690-1-git-send-email-cesarb@cesarb.net> <1254060189.20648.462.camel@desktop>
In-Reply-To: <1254060189.20648.462.camel@desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker escreveu:
> On Sun, 2009-09-27 at 10:53 -0300, Cesar Eduardo Barros wrote:
>>  #define
>> WARN_ON_ONCE(condition)        ({                              \
>> -       static int __warned;                                    \
>> +       static bool __warned;                                   \
>>         int __ret_warn_once = !!(condition);                    \
> 
> Could __ret_warn_once be bool also ? It looks like just another
> conditional variable..

Yes, it could (as long as either it is converted back to int in the 
return of the macro, or all users do not care about the macro's return 
type). However, the justification used for the printk_once patch (and 
this WARN_ONCE patch) does not apply directly anymore, since the code is 
different (to start with, it is not a static variable).

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZGMUdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZGMUdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZGMUdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:33:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:52658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbZGMUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Dnm68hnB+qZcOA0XymEUNTbUSa99LGJDPvwJtClvuQsDZz8IFJNcWOOFr7x82bHfl9
         ePeLshNspMG0HqZxXoRPhfqc+utnoL4n8VSsJsV8yr7A2A/UQwFYPKy2nnc68gQwvGh2
         PNeOu1r1nZMtgNMo7pQO6PExWA1Uul4g1aKlU=
Message-ID: <4A5B99FD.5030505@gmail.com>
Date: Mon, 13 Jul 2009 22:33:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: iwl: potential deadlock?
References: <4A5B8C60.9000600@gmail.com> <1247516320.17896.1640.camel@rc-desk>
In-Reply-To: <1247516320.17896.1640.camel@rc-desk>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 10:18 PM, reinette chatre wrote:
> On Mon, 2009-07-13 at 12:34 -0700, Jiri Slaby wrote:
>> we found a potential deadlock in iwl code by our tool.
> 
> What tool is this?

It's called stanse[1], we still work on it.

>> iwl_update_tkip_key()
>> -> spin_lock_irqsave(&priv->sta_lock)
>> -> iwl_send_add_sta()
> 
> iwl_send_add_sta() is called here with flags = CMD_ASYNC
> 
> In iwl_send_add_sta() we have:
> 	if (ret || (flags & CMD_ASYNC))
> 		return ret;

Yes, you're right, indeed. Thanks for the explanation.

[1] http://iti.fi.muni.cz/stanse/

Return-Path: <linux-kernel-owner+w=401wt.eu-S934361AbZDBUYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361AbZDBUYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934277AbZDBUYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:24:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:39963 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934248AbZDBUX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AX2h7G/nKq+pFZvLX+kwrzHzXFmNAhuATEO8AyeoXCESOi3A6GOjI1vKdvLyurbz/z
         a7HZRmwFf4xXlRRbVSXFWMbY3f48AsgJfeVUzq79RkdormEv7aq9Ajb7hAhIKYbj/YWD
         O7W4taS4bYZ3UUp1sIe2WJCbT9mo66JKUCwJM=
Message-ID: <49D51EDD.4060902@gmail.com>
Date: Thu, 02 Apr 2009 22:23:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>,
       Christophe Lermytte <christophe.lermytte@thomson.net>,
       linux-kernel@vger.kernel.org
Subject: Re: mutex_lock_slowpath warning using mxser tty driver (input/output
 error)
References: <1238689565.14822.99.camel@thom>	<1238696349.5133.25.camel@laptop> <20090402194401.154bbc36@lxorguk.ukuu.org.uk>
In-Reply-To: <20090402194401.154bbc36@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2009 08:44 PM, Alan Cox wrote:
>> It appears to want to lock a mutex in interrupt context, something
>> that's a definite no-no.
>>
>> CCed the folks who might know a thing or two about the driver.
> 
> Moxa is not a USB driver so the USB trace at the end makes no sense at
> all.

Yes, unreliable stack entries, but echo_set_canon_col is called from irq
context and locks mutex.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZGLH6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZGLH6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 03:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZGLH6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 03:58:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57900 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZGLH6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 03:58:38 -0400
Message-ID: <4A599820.9030905@redhat.com>
Date: Sun, 12 Jul 2009 11:00:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, kvm <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [FIX REQUEST] Need better management for include/linux/*.h
References: <1247303928.2678.46.camel@ht.satnam>
In-Reply-To: <1247303928.2678.46.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2009 12:18 PM, Jaswinder Singh Rajput wrote:
> Hello all,
>
> As include/linux/*.h file count is going to reach 1000.
>
> We need to do some better techniques to reduce the number of files and
> add some hierarchy levels like sub directories where possible.
>
> Like atmel is not exporting to user-space we can easily do :
>
> include/linux/atmel-mci.h     ->  include/linux/atmel/mci.h
> include/linux/atmel_pdc.h     ->  include/linux/atmel/pdc.h
> include/linux/atmel-pwm-bl.h  ->  include/linux/atmel/pwm-bl.h
> include/linux/atmel_pwm.h     ->  include/linux/atmel/pwm.h
> include/linux/atmel_serial.h  ->  include/linux/atmel/serial.h
> include/linux/atmel-ssc.h     ->  include/linux/atmel/ssc.h
> include/linux/atmel_tc.h      ->  include/linux/atmel/tc.h
>
> Also these files are not exporting :
>
> include/linux/kvm_host.h      ->  include/linux/kvm/host.h
> include/linux/kvm_para.h      ->  include/linux/kvm/para.h
> include/linux/kvm_types.h     ->  include/linux/kvm/types.h
>
>    

IMO a much better move is to place non-ABI files (and the #ifdef KERNEL 
parts of ABI files) outside include/linux.


-- 
error compiling committee.c: too many arguments to function


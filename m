Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYHNHRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYHNHRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 03:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYHNHQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 03:16:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:33598 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYHNHQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 03:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TI0hMVPYtNR/2BQsam5qJNA7klV0wq4wsY263Exwu455oCDzbuxtYKRWRSrV8bQH3q
         tp3JMYv/fPEq4efjGtx0vFQKZ1B3Z8ADxpdfKtlaKXbSItOKl6KSoWLqhqYMw08ptTh9
         DiGoRJQ45EQRoaUggiewWarttCaxHWUXQWOvc=
Message-ID: <b6a2187b0808140016m63c7d9d9s960014ec5cd9f3c5@mail.gmail.com>
Date: Thu, 14 Aug 2008 15:16:58 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440808131133o133e1dfftdfcc076a1100afb6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
	 <20080813141629.GD19397@elte.hu>
	 <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com>
	 <b6a2187b0808131033m25a7e147x98235a48abd3eb3c@mail.gmail.com>
	 <20080813173940.GA32214@elte.hu>
	 <86802c440808131046s4df84ba9va12d45897cf6affa@mail.gmail.com>
	 <86802c440808131133o133e1dfftdfcc076a1100afb6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 2:33 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:

>>>> > With 16 CPUs, it still hangs, but now the console is showing the
>>>> > errors as intended.
>>>> > ... but it is supposed to hang?

> please check the attached patch. it should fix the new regression and
> will not hang.

Ok, booted up and not hanged, but those messages below don't show up
anywhere. I've tested with CONFIG_NR_CPUS=16 and 8 as well. Just got 8
cpus

More than 8 CPUs detected - skipping them.
Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.

# cat /sys/devices/system/cpu/possible
0-7

CONFIG_X86_32=y
CONFIG_X86_PC=y


Looks like it's not going into this condition
+        if (def_to_bigsmp && nr_cpu_ids > 8) {


Shall this be put back so that it'll show the message?
-       if (def_to_bigsmp && apicid > 8) {
-               printk(KERN_WARNING
-                       "More than 8 CPUs detected - skipping them.\n"
-                       "Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.\n");
-       }


Thanks,
Jeff.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYJTNQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYJTNQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYJTNP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:15:59 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:18979 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYJTNP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YrKs3OLCbmLyknXtf+henKfegk2V9EScp2tGk4hKUKtpL9j5Ipgbdn4xXgaqT+7sO2
         QZn6HIdAEqSIzGKeIDxGIFKyZjTWlmPEyr/uJgENy0lnRUChCyyegSYBhgGgX10B8igv
         jKMD51DV5GDLo8TV9UDF97SAqLPurg5EwlJzE=
Message-ID: <5d6222a80810200615k60d6f523p9bcd71d8cb070a39@mail.gmail.com>
Date: Mon, 20 Oct 2008 11:15:56 -0200
From: "Glauber Costa" <glommer@gmail.com>
To: "Max Kellermann" <mk@cm4all.com>
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than 120 seconds"
Cc: "Glauber Costa" <glommer@redhat.com>, linux-kernel@vger.kernel.org,
       ijc@hellion.org.uk, "Grant Coady" <grant_lkml@dodo.com.au>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Tom Tucker" <tom@opengridcomputing.com>, gorcunov@gmail.com
In-Reply-To: <20081020065149.GA11213@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <20081017143301.GA18522@poweredge.glommer>
	 <20081020065149.GA11213@rabbit.intern.cm-ag>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 4:51 AM, Max Kellermann <mk@cm4all.com> wrote:
> On 2008/10/17 16:33, Glauber Costa <glommer@redhat.com> wrote:
>> That's probably something related to apic congestion.
>> Does the problem go away if the only thing you change is this:
>>
>>
>> > @@ -891,11 +897,6 @@ do_rest:
>> >             store_NMI_vector(&nmi_high, &nmi_low);
>> >
>> >             smpboot_setup_warm_reset_vector(start_ip);
>> > -           /*
>> > -            * Be paranoid about clearing APIC errors.
>> > -           */
>> > -           apic_write(APIC_ESR, 0);
>> > -           apic_read(APIC_ESR);
>> >     }
>>
>>
>> Please let me know.
>
> Hello Glauber,
>
> I have rebooted the server with 2.6.27.1 + this patchlet an hour ago.
> No problems since.
>
> Hardware: Compaq P4 Xeon server, Broadcom CMIC-WS / CIOB-X2 board.
> Tell me if you need more detailed information.
>

There's a patch in flight from cyrill that probably fixes your problem:
http://lkml.org/lkml/2008/9/15/93

The checks are obviously there for a reason, and we can't just wipe
them out unconditionally ;-) So can you check please that you are also
covered by the case provided?

> On 2008/10/20 08:27, Ian Campbell <ijc@hellion.org.uk> wrote:
>> The issue I see still occurs well before those changesets. I have
>> seen it with v2.6.25 but v2.6.24 survived for 7 days without issue
>> (my threshold for a good kernel is 7 days, hence bisecting is a bit
>> slow...).
>
> Hello Ian,
>
> it seems we're hunting down different bugs after all.  Too bad, I
> hoped I could have solved your problem, too.  Our machine has been
> running well over the weekend with the patch I posted; with faulty
> kernels, the problem would occur after a few minutes.
>
> Max
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Glauber  Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."

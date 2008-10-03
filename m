Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYJCTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYJCTu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYJCTuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:50:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:39196 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYJCTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=GB5M4/a8oYQiQC4RMagB08uEmnDhJVt6ZHm5SkD4Z5cW6r+j6MGKWZ2GmbBYSOTGSs
         S4RFnvGQSwfUnm+kKFblqTzgkObVMaMsQ6zM4FUnpZQg5mVl4w3hqO6LwGrFqevE292n
         0KokO7JePBI8viBjv+YkNBPiKYfNMkynpfDlw=
Message-ID: <48E67773.50402@tuffmail.co.uk>
Date: Fri, 03 Oct 2008 20:50:11 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Alan Jenkins <aj504@student.cs.york.ac.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -tip] Tracing/fastboot: Only trace non-module initcalls
References: <48E62089.7050006@gmail.com> <48E659CB.5030902@tuffmail.co.uk> <c62985530810031059v5ed44e04qebaf9453710e76c1@mail.gmail.com>
In-Reply-To: <c62985530810031059v5ed44e04qebaf9453710e76c1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 2008/10/3 Alan Jenkins <aj504@student.cs.york.ac.uk>:
>   
>> Sorry to butt in.  I think tracing module initcalls was a deliberate addition by Arjan (a06e1c2b448b317bc141934879cbbbed8319b4d4).
>>
>> Maybe you use an initrd and that affects the trace?  It would be nice to see the "before" svg as well as the "after", to explain the change.
>>
>> Thanks
>> Alan
>>     
>
>
> Hi Alan,
>
> The script bootgraph.pl in -tip stops the analyzing when it sees
> "Freeing unused kernel memory". That's
> exactly when the built-in initcalls are finished.
> And as a result, the graph produced with dmesg always finishes at this point.
>
> If you try to generate a graph whithout this limitation, you will not
> be able to see something interesting because
> the script will not find a lot of initcalls with a long enough time
> proportion against the total boot time.
> Perhaps it can be improved in that way but unfortunately I don't know
> any word in Perl....
>   

If you want to disable non-module initcalls, then what do you have left
that you want to trace after "Freeing unused kernel memory"?

On my desktop dmesg I can see that the initramfs is loaded and started
some time before the initcalls finish.  The initramfs includes udev
which loads many modules; I see network, usb, sata being initialised
before the "Freeing unused kernel memory" message.  Um...  your changes
will _not_ stop the initcalls from these modules being shown.

So I think your patch description is a bit inaccurate, and I don't
understand what you are trying to achieve.

Thanks
Alan

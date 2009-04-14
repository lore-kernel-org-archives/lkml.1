Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZDNISP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZDNISP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZDNISB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:18:01 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37848 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZDNISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bplpS3BN9x1If/kPN2NE183yuvLA+ECdmYMJigiVQPyhJ0MSkxl1PUeQpLzme6O3FO
         JAXkVkedBq6/evqlPAbeWcvY8YWerfd8ldJbfck6me89vVGXFRR9U0Bgmw3kUh31wCGt
         yb5YCrSHBsDlreFnR3wOvm9IJNKMmSKWFSoxo=
MIME-Version: 1.0
In-Reply-To: <878wm3903h.fsf@basil.nowhere.org>
References: <e2e108260904130422k2ac92e64jb5aff1cc2adc8da0@mail.gmail.com>
	 <878wm3903h.fsf@basil.nowhere.org>
Date: Tue, 14 Apr 2009 10:17:58 +0200
Message-ID: <e2e108260904140117t274815c6uebe5438ba2bf17b6@mail.gmail.com>
Subject: Re: dm-multipath and write request ordering
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 9:16 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Bart Van Assche <bart.vanassche@gmail.com> writes:
>> - Is it correct that round-robin load balancing can only work
>> correctly in such a setup with proper support for write barriers in
>> the device mapper ?
>
> No opinion on that one.

What I'm worried about is that write requests that have been passed to
dm_mp could arrive in another order at the target because of the
variable transport time of protocols like TCP/IP. This could cause
newer data to be overwritten by older data. Separating those write
requests by a barrier won't help because dm_mp ignores barriers.

Bart.

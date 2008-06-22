Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbYFVGeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbYFVGeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 02:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYFVGdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 02:33:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:15031 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYFVGdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 02:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vXerULQldZM2gIYpx7mzXGp1759KHf/K0Bpmoggwpx7LFVXi7Uu6q/+Hfx6f9/eWT8
         o3tzYPhzWkqsDLa6RAYCYLNXnuxUK/g1Q8JWL4r4nlSV+EegabKmzYnlSXv6hmbOViOv
         6zXQsosKyoHG1ML4HGfUXuAhRg6LytR6cwRdc=
Message-ID: <e2e108260806212333q669a0ae5o9df105652352ae89@mail.gmail.com>
Date: Sun, 22 Jun 2008 08:33:51 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Eric Smith" <eric@brouhaha.com>
Subject: Re: Any lightweight way for one thread to force another thread to suspend execution?
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <49370.71.139.37.220.1214099737.squirrel@ruckus.brouhaha.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
	 <877iciyjcs.fsf@basil.nowhere.org>
	 <49370.71.139.37.220.1214099737.squirrel@ruckus.brouhaha.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 3:55 AM, Eric Smith <eric@brouhaha.com> wrote:
> Andi wrote:
>> Any such mechanism will need a syscall, and it's unlikely that
>> any syscall will get much cheaper than a kill(SIGSTOP)
>
> But is there a way for the process sending the SIGSTOP to wait until it
> has taken effect?  I need a method to *synchronously* stop another
> thread.  That's why I thought I probably needed something more
> elaborate than SIGSTOP, though I'd like to minimize the number of
> system calls required.

Are you aware that SIGSTOP suspends all the threads in a process
instead of a single thread ? (Note: this is how the NPTL behaves. With
LinuxThreads it was possible to suspend a single thread via SIGSTOP,
but this was a violation of the POSIX standards.)

Bart.

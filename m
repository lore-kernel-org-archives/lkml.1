Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZIYXy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZIYXy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 19:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZIYXy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 19:54:57 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39659 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZIYXy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 19:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MQYsJL+UU+zGUwrmfWdKsX2kDV4H3mv9wrNhDkmew4dVrtLpo9ClOuVfuPt8iKJwD4
         FugMq7NMvgFSwAZYrJrDL9B7VlR8DlTXMLG3hU4PSRG/zy5qPcbhXZrDWXJwa1fj5Y/J
         myhuW7uyoMfDM98yKiMsaBMeyA8rxTOPlKY9s=
MIME-Version: 1.0
In-Reply-To: <4ABD50A5.5000309@goop.org>
References: <4ABD3EC2.1020104@goop.org>
	 <73c1f2160909251556g40f3c5b1o1c29b7f012912873@mail.gmail.com>
	 <4ABD50A5.5000309@goop.org>
Date: Fri, 25 Sep 2009 19:54:59 -0400
Message-ID: <73c1f2160909251654v1c9f8eb9k9211f1e0c5e15f67@mail.gmail.com>
Subject: Re: [GIT PULL] x86: unify sys_iopl
From: Brian Gerst <brgerst@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 7:22 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 09/25/09 15:56, Brian Gerst wrote:
>> The correct fix is to move set_iopl_mask into do_iopl.  sys_iopl
>> should only be a wrapper around do_iopl to manage the different
>> calling convention used by 32-bit and 64-bit.
>>
>
> The patch eliminates that distinction, so I guess do_iopl should really
> be folded into sys_iopl (though the compiler effectively does that
> anyway by inlining it).

Using task_pt_regs is less effecient than getting the pointer directly
from the syscall entry code.  On 32-bit it probably doesn't matter too
much, but on 64-bit, you still need the special stub code in
entry_64.S to put the full pt_regs struct on the stack.  Changing the
calling conventions should be a seperate patch, and should be done for
all pt_regs-using syscalls.

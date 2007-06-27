Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbXF0Dpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbXF0Dpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXF0Dpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:45:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:28949 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbXF0Dp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bAa2F0qyarAjDTnxwmhZV+9t/sl5WGmHdAcpdaDZ1epiqGga3wnUJlrJ74QjZtdGcAIis2zBd7r+AVdQppmjh0z9eCfiGcoVcnreObRmCtD53cJ+jJzxFaMmz00AGXkbK8kieUG5cMO2p5s6QjmL2JNDe/uQO8u0uWP7/+DqsZ8=
Message-ID: <a36005b50706262045g79c4accak21fea740fdc1bffd@mail.gmail.com>
Date: Tue, 26 Jun 2007 20:45:28 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4681D45F.7080309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
	 <4681D45F.7080309@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Rik van Riel <riel@redhat.com> wrote:
> Since programs can get back free()d memory after a malloc(),
> with the old contents of the memory intact, surely your
> MAP_NONZERO behavior could be the default for programs that
> can get away with it?
>
> Maybe we could use some magic ELF header, similar to the
> way non-executable stack is handled?

No.  This is an implementation detail of the libc version.  The malloc
as compiled today is expecting brk-ed memory to be zeroed.  This
default can of course be changed (it's a simple define) but you cannot
make this the default behavior for brk.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbXF0RBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbXF0RBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbXF0RBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:01:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:43341 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXF0RBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t1w4Ltc/w1HYVoGWykiwXCX8inq91Lza7LPEHlPBkMi80/i4CQPXCHjklytYrpspI6GzWBR40aqDTI2xvHUgSOWeZprCK17w8KOXcGhUeKmqrLOj0xUjKGjkPe10lrl+GsFt361R9C3r1gk3TTbteReCp0xdqDJEkNwVFHzsxl0=
Message-ID: <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
Date: Wed, 27 Jun 2007 10:01:46 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
	 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>
	 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
	 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
	 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Hugh Dickins <hugh@veritas.com> wrote:
> Not so: if an mmap can be done by extending either adjacent vma (prot
> and flags and file and offset all match up), that's what's done and no
> separate vma is created.  (And adjacent vmas get merged when mprotect
> removes the difference in protection.)

mmap return values are randomized.  If they would be mergable
something would be wrong.


> I don't think there's any such reason to prefer brk to mmap.

Talk to the Quadrics people.  Some of their interconnect adapters
incur significant costs with separate VMAs.


> Please let me know if you've a test case which shows more vmas than
> expected.

Not related to this, but we already have "too many" VMAs for some
definition of "too many".  Since we split VMA when the protection
changes each thread stack consists at least of two VMA (three for
ia64).  There was an approach at some point to push the access flags
down and allow VMAs to stretch further.  Why was this deemed
unsuitable?  It could have quite a bit with situations with many
threads (Java).  As I've told back when this came up, we had one
customer where the VMA lookup actually showed up in profiles.

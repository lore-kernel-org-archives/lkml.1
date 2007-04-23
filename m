Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbXDWPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbXDWPa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbXDWPa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:30:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:44868 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXDWPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lpuV5ge0IlXSOMO1VvjWVKuL6Ry9/KfYMBsMVq5vfpKAsHR/7pjTFcSL07aMT3+Aexm/GPflJTIPjxNqyJF47Ovbko0mfRz6JEo9+yogG4Zx6FH7uWzur/B3kYUoX/JAy9c3pwCmYK4ieHikECBtUiEFsw5K5iqey4bQfpf2nCo=
Message-ID: <a36005b50704230830p2a4d55e2i61627b00788cd4d2@mail.gmail.com>
Date: Mon, 23 Apr 2007 08:30:57 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Pierre Peiffer" <pierre.peiffer@bull.net>
Subject: Re: [PATCH -mm] 64bit-futex - provide new commands instead of new syscall
Cc: "Jakub Jelinek" <jakub@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net
In-Reply-To: <462CC449.6090004@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321095432.207136068@bull.net>
	 <20070321100542.438317770@bull.net>
	 <20070327110757.GY355@devserv.devel.redhat.com>
	 <462CC449.6090004@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Pierre Peiffer <pierre.peiffer@bull.net> wrote:
> Following this mail sent few weeks ago, here is a patch which should meet your
> requirements. [...]

It looks mostly good.  I wouldn't use the high bit to differentiate
the 64-bit operations, though.  Since we do not allow to apply it to
all operations the only effect will be that the compiler has a harder
time generating the code for the switch statement.  If you use
continuous values a simple jump table can be used and no conditionals.
 Smaller and faster.

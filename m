Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYDOSNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYDOSNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYDOSNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:13:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:13267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYDOSNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:13:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=HDZ5UPMMbWk9DOEvgejTJV0zPQyKs3KG/x2tft5c3nnXnuA5Hd1cvJjlPrsJq+5tQ
	TGqt6ogUtk1D2CuhOh0mA==
Message-ID: <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com>
Date: Tue, 15 Apr 2008 11:13:19 -0700
From: "Paul Menage" <menage@google.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Cc: "Andrew Morton" <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
       serue@us.ibm.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
In-Reply-To: <20080415171359.GA352@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48036677.3010807@linux.vnet.ibm.com>
	 <20080414170709.736819b6.akpm@linux-foundation.org>
	 <20080415171359.GA352@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 10:13 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>
>  Let's suppose the process with a lot of threads does exit_group() and nobody
>  else uses this ->mm. How many time we will re-assign mm->owner and iterate
>  over the all threads in system ?
>

In general we won't get to the third loop, since one of the first two
loops (children or siblings) will find another mm user.

Paul

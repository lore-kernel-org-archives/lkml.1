Return-Path: <linux-kernel-owner+w=401wt.eu-S933111AbXA3GdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbXA3GdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 01:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933116AbXA3GdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 01:33:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:38715 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbXA3GdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 01:33:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RMR8P7/nc9Xn1l0V5cDEHjvYeo7HHv93BQ7wKRtc9F1KXk1IRe9c+cLOB/kq92xX+Hi0HsVuHdjPzqS/JuUP7KL5VzSY063tEDhxUEnQIWt1YY4ISFGILh92cYvWQqpcIpioRBTi5o5GCOXzBjHa8acSyzeCPnDtSUu6jsBVfZ0=
Message-ID: <84144f020701292233x636f3c87if09df48416182f3c@mail.gmail.com>
Date: Tue, 30 Jan 2007 08:33:18 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: [PATCH] tty: cleanup release_mem
Cc: "Alan Cox" <alan@redhat.com>, "Christoph Hellwig" <hch@lst.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070129195605.f5d50302.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070128171244.GA21378@lst.de>
	 <20070129120100.GA4338@devserv.devel.redhat.com>
	 <20070129181235.GA9063@lst.de>
	 <20070129190604.GA20564@devserv.devel.redhat.com>
	 <20070129195605.f5d50302.akpm@osdl.org>
X-Google-Sender-Auth: ed2acb915443b772
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/07, Andrew Morton <akpm@osdl.org> wrote:
> BUG: unable to handle kernel paging request at virtual address 6b6b6bdf

Use after free. The new code does module_put() _after_
free_tty_struct() which is obviously wrong.

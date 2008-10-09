Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYJIUyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYJIUyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 16:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYJIUyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 16:54:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58556 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYJIUyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:54:35 -0400
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       arnd@arndb.de, linux-kernel@vger.kernel.org
In-Reply-To: <20081009194350.GA31214@us.ibm.com>
References: <20081009190405.13A253CB@kernel>
	 <20081009190406.1B257119@kernel>  <20081009194350.GA31214@us.ibm.com>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 13:54:31 -0700
Message-Id: <1223585671.11830.40.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 14:43 -0500, Serge E. Hallyn wrote:
> Hmm, I don't know too much about aio, but is it possible to succeed with
> io_getevents if we didn't first do a submit?  It looks like the contexts
> are looked up out of current->mm, so I don't think we need this call
> here.
> 
> Otherwise, this is neat.

Good question.  I know nothing, either. :)

My thought was that any process *trying* to do aio stuff of any kind is
going to be really confused if it gets checkpointed.  Or, it might try
to submit an aio right after it checks the list of them.  I thought it
best to be cautious and say, if you screw with aio, no checkpointing for
you!

-- Dave


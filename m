Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbYIAXPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbYIAXPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYIAXPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:40528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYIAXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:10 -0400
Date: Mon, 1 Sep 2008 16:03:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 0/13] Turn hrtimers into a range capable timer
Message-ID: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a follow-on the the nanosecond select/poll series.

The goal of this series is to introduce the capability into hrtimers to
deal with a "range" rather than a specific point in time.
(Several people discussed this recently, but we've been toying with the
concept for a while)

In addition, in the last patch of the series, the patches make select()
and poll() use these range timers with a standard "slack" that comes
from
1) a per process task_struct value
2) a "the longer the sleep the more the slack" function that Linus wrote


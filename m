Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbZLSLzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbZLSLzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 06:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZLSLzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 06:55:20 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:59565 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZLSLzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 06:55:18 -0500
Date: Sat, 19 Dec 2009 15:02:06 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <1257480306.20091219150206@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: epoll'ing tcp sockets for reading
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello people, I have a question about epoll'ing tcp sockets.

Is it possible (with epoll or some other good method) to get userspace
notified not only of the fact that some data has become available
for the socket, but also of the respective _size_ available for
reading connected with this exact event?

Yes, read'ing until EAGAIN or using FIONREAD would provide this
sort of information, but there is a problem. In case of subsequent
continuous data arrival, an application could get stuck reading
data for one socket infinitely (after epoll return, just before
the next epoll), unless it implements some kind of artifical safety
measures.

To my understanding, EPOLLONESHOT does not suffice here, because
it only "fixes" the epoll'ing part but not the read'ing part, whereas
_both_ epoll'ing and read'ing appear to be responsible. Therefore,
"event atomicity" is lost anyway. Or am I wrong?

(Please CC me, I'm not subscribed)

Thank you!

Nikolai ZHUBR



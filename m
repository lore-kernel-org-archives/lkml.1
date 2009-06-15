Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbZFOUsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbZFOUsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbZFOUsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:48:32 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:52110 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZFOUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=R1u+szOykuobfyHKOLvjzt1jr08egEN7g3iaIL01u/zXMNefJI5EDEKzdpprowJEaW
         tle/PUlZXUjGfmIfTcjLcLpsD4pYtHql1HXwPCFSEvtVwbk++VUYha3avHq88YIcgveB
         B2z4C17czcJ2dJNoiRtCy2UAxjWRLHyqhpwK4=
MIME-Version: 1.0
Date: Mon, 15 Jun 2009 22:48:33 +0200
Message-ID: <c384c5ea0906151348w3835632aob0034a4b877163bc@mail.gmail.com>
Subject: Expected behaviour for device driver aio_read(), aio_write() and 
	(girl)friends?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: linux-kernel@vger.kernel.org, kernelnewbies <kernelnewbies@nl.linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as I cannot find any existing drivers using aio_read()/write(), and
the interface has changed since LDD3 now supporting vectored I/O,
where can I get more information on it?

Some questions I came up with:

For a multi vector I/O, can aio_read() still return the number of bytes?
Must it do so for synchronous I/O (either requested or possible) only,
or is returning the queued amount of I/O bytes also valid?
Or, must it still return -EIOCBQUEUED if everything was queued?

For multi-segment vectored IO, what must aio_complete return in res2?
The total of bytes across all completed I/O vectors?
And what if the I/O fails half-way the segments?

LDD3 says the first result of aio_complete() is the "usual result
status" for the operation.
I'm not sure what that is for multi-vectored I/O; I guess the total
amount of bytes transferred?



Regards,
-- 
Leon

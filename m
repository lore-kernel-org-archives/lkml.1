Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbZDVOB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbZDVOB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbZDVNyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:54:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:44316 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbZDVNyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=iWvgmrgcmLM4LKkDcFvHVU9AemNYV5dzeTVdkZKDQpQv6bYDKr2x02JomG1U74uMhL
         VV4x8B7g1GNkfJkn75b62BxTeIEBM5FW/QUpmKdFKTowOaUpQj/SQUeI07reXQpy5lH6
         tyQ2OOhDdqJJLA17xUcp/EgCh76oLmsHmZxb4=
MIME-Version: 1.0
Date: Wed, 22 Apr 2009 17:54:21 +0400
Message-ID: <f44001920904220654u40338ad1sd291926067a00913@mail.gmail.com>
Subject: Why module_exit() is void and not int? What about can_unload()?
From: Igor Zhbanov <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Sometimes module doesn't want to be unloaded. But now the only way to prevent
unloading (except hanging in module_exit()) is incrementing of module
usage count.

But sometimes module couldn't know whether it is a good time for unload,
and can check a condition only in module_exit() handler. But it is impossible
to return error (something like EAGAIN), since module_exit() is void.

Why not to have int module_exit()? Or some other way to tell the kernel
at module_exit() time that module cannot be unloaded?

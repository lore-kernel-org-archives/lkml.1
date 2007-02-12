Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXBLXsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXBLXsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030518AbXBLXsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:48:04 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3387 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030525AbXBLXrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:47:41 -0500
Subject: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)" to
	"array_for_each(index, array)"
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 12 Feb 2007 15:47:50 -0800
Message-Id: <1171324070.1528.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that most of the sizeof(array)/sizeof(array[0])
conversions have been done (there are about 800 done
and about another 130 left), perhaps it could be
useful to change the code to use a define similar
to the list_for_each

#define list_for_each(pos, head) \
	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
        	pos = pos->next)

perhaps

#define array_for_each(index, array) \
	for ((index) = 0; (index) < ARRAY_SIZE((array)); (index)++)



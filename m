Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbXEYPKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbXEYPKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 11:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXEYPKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 11:10:25 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:51284 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbXEYPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 11:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pMX7q5U+ZZrGiGr57ooRxFr0y0ThXhK3bhFNMPDMkAFA4mAQoSxW2gpV2nciTu9vmvETyzs8a5gtkNAtZjpm3SXUkQUmmO+6L1qA6sftVeQmr3KerrXHpbGeYp3oK7lWC13+pBFg8yA2ua61zpnodE8HLzporf6c5ciR14sOLms=
Message-ID: <2bd9ebfa0705250810l4878c33ene551235247a4a896@mail.gmail.com>
Date: Fri, 25 May 2007 11:10:23 -0400
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Reg: redundancy in inet socket
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

list_for_each_rcu(p, &inetsw[sock->type]) {
		answer = list_entry(p, struct inet_protosw, list);

		/* Check the non-wild match. */
		if (protocol == answer->protocol) {
			if (protocol != IPPROTO_IP)
				break;
		} else {
			/* Check for the two wild cases. */
			if (IPPROTO_IP == protocol) {
				protocol = answer->protocol;
				break;
			}
			if (IPPROTO_IP == answer->protocol)
				break;
		}

i think there is a problem in this code because if (protocol ==
answer->protocol) will be more like an assignment rather then
comparison
pl cc to me.
TEJ

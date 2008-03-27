Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYC0LZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYC0LZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYC0LZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:25:45 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54294 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754231AbYC0LZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:25:45 -0400
Date: Thu, 27 Mar 2008 06:25:39 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/4] x86_64 boot: Add linked list of struct
 setup_data
Message-Id: <20080327062539.5cbcb925.pj@sgi.com>
In-Reply-To: <1206601748.3067.22.camel@caritas-dev.intel.com>
References: <1206601748.3067.22.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		switch (data->type) {
+		default:
+			break;
+		}

Isn't that switch statement equivalent to -always- breaking, as in:

+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		break;

I doubt you want to do that.  I suppose what you want to do is check for
data == NULL instead, as in:

+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		if (!data)
+			break;

???

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214

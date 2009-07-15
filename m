Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZGOWON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZGOWON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZGOWON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:14:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52562 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbZGOWOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:14:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] connector: clean up grammar/style in documentation
Date: Wed, 15 Jul 2009 18:14:08 -0400
Message-Id: <1247696049-15699-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247696049-15699-1-git-send-email-vapier@gentoo.org>
References: <1247696049-15699-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The grammar in most of this file is slightly off, and some sections are
hard to read due to lack of visual clues breaking up related material.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/connector/connector.txt |  119 +++++++++++++++++----------------
 1 files changed, 61 insertions(+), 58 deletions(-)

diff --git a/Documentation/connector/connector.txt b/Documentation/connector/connector.txt
index ad6e0ba..847f0d8 100644
--- a/Documentation/connector/connector.txt
+++ b/Documentation/connector/connector.txt
@@ -5,10 +5,10 @@ Kernel Connector.
 Kernel connector - new netlink based userspace <-> kernel space easy
 to use communication module.
 
-Connector driver adds possibility to connect various agents using
-netlink based network.  One must register callback and
-identifier. When driver receives special netlink message with
-appropriate identifier, appropriate callback will be called.
+The Connector driver adds makes it easy to connect various agents using a
+netlink based network.  One must register a callback and an identifier.
+When the driver receives a special netlink message with the appropriate
+identifier, the appropriate callback will be called.
 
 From the userspace point of view it's quite straightforward:
 
@@ -17,10 +17,10 @@ From the userspace point of view it's quite straightforward:
 	send();
 	recv();
 
-But if kernelspace want to use full power of such connections, driver
-writer must create special sockets, must know about struct sk_buff
-handling...  Connector allows any kernelspace agents to use netlink
-based networking for inter-process communication in a significantly
+But if kernelspace wants to use the full power of such connections, the
+driver writer must create special sockets, must know about struct sk_buff
+handling, etc...  The Connector driver allows any kernelspace agents to use
+netlink based networking for inter-process communication in a significantly
 easier way:
 
 int cn_add_callback(struct cb_id *id, char *name, void (*callback) (void *));
@@ -32,15 +32,15 @@ struct cb_id
 	__u32			val;
 };
 
-idx and val are unique identifiers which must be registered in
-connector.h for in-kernel usage.  void (*callback) (void *) - is a
-callback function which will be called when message with above idx.val
-will be received by connector core.  Argument for that function must
+idx and val are unique identifiers which must be registered in the
+connector.h header for in-kernel usage.  void (*callback) (void *) is a
+callback function which will be called when a message with above idx.val
+is received by the connector core.  The argument for that function must
 be dereferenced to struct cn_msg *.
 
 struct cn_msg
 {
-	struct cb_id 		id;
+	struct cb_id		id;
 
 	__u32			seq;
 	__u32			ack;
@@ -55,92 +55,95 @@ Connector interfaces.
 
 int cn_add_callback(struct cb_id *id, char *name, void (*callback) (void *));
 
-Registers new callback with connector core.
+ Registers new callback with connector core.
 
-struct cb_id *id 		- unique connector's user identifier.
-			  	  It must be registered in connector.h for legal in-kernel users.
-char *name 			- connector's callback symbolic name.
-void (*callback) (void *)	- connector's callback.
+ struct cb_id *id		- unique connector's user identifier.
+				  It must be registered in connector.h for legal in-kernel users.
+ char *name			- connector's callback symbolic name.
+ void (*callback) (void *)	- connector's callback.
 				  Argument must be dereferenced to struct cn_msg *.
 
+
 void cn_del_callback(struct cb_id *id);
 
-Unregisters new callback with connector core.
+ Unregisters new callback with connector core.
+
+ struct cb_id *id		- unique connector's user identifier.
 
-struct cb_id *id 		- unique connector's user identifier.
 
 int cn_netlink_send(struct cn_msg *msg, u32 __groups, int gfp_mask);
 
-Sends message to the specified groups.  It can be safely called from
-softirq context, but may silently fail under strong memory pressure.
-If there are no listeners for given group -ESRCH can be returned.
+ Sends message to the specified groups.  It can be safely called from
+ softirq context, but may silently fail under strong memory pressure.
+ If there are no listeners for given group -ESRCH can be returned.
 
-struct cn_msg *			- message header(with attached data).
-u32 __group			- destination group.
+ struct cn_msg *		- message header(with attached data).
+ u32 __group			- destination group.
 				  If __group is zero, then appropriate group will
 				  be searched through all registered connector users,
 				  and message will be delivered to the group which was
 				  created for user with the same ID as in msg.
 				  If __group is not zero, then message will be delivered
 				  to the specified group.
-int gfp_mask			- GFP mask.
+ int gfp_mask			- GFP mask.
 
-Note: When registering new callback user, connector core assigns
-netlink group to the user which is equal to it's id.idx.
+ Note: When registering new callback user, connector core assigns
+ netlink group to the user which is equal to it's id.idx.
 
 /*****************************************/
 Protocol description.
 /*****************************************/
 
-Current offers transport layer with fixed header.  Recommended
-protocol which uses such header is following:
+The current framework offers a transport layer with fixed headers.  The
+recommended protocol which uses such a header is as following:
 
 msg->seq and msg->ack are used to determine message genealogy.  When
-someone sends message it puts there locally unique sequence and random
-acknowledge numbers.  Sequence number may be copied into
+someone sends a message, they use a locally unique sequence and random
+acknowledge number.  The sequence number may be copied into
 nlmsghdr->nlmsg_seq too.
 
-Sequence number is incremented with each message to be sent.
+The sequence number is incremented with each message sent.
 
-If we expect reply to our message, then sequence number in received
-message MUST be the same as in original message, and acknowledge
-number MUST be the same + 1.
+If you expect a reply to the message, then the sequence number in the
+received message MUST be the same as in the original message, and the
+acknowledge number MUST be the same + 1.
 
-If we receive message and it's sequence number is not equal to one we
-are expecting, then it is new message.  If we receive message and it's
-sequence number is the same as one we are expecting, but it's
-acknowledge is not equal acknowledge number in original message + 1,
-then it is new message.
+If we receive a message and its sequence number is not equal to one we
+are expecting, then it is a new message.  If we receive a message and
+its sequence number is the same as one we are expecting, but its
+acknowledge is not equal to the acknowledge number in the original
+message + 1, then it is a new message.
 
-Obviously, protocol header contains above id.
+Obviously, the protocol header contains the above id.
 
-connector allows event notification in the following form: kernel
+The connector allows event notification in the following form: kernel
 driver or userspace process can ask connector to notify it when
-selected id's will be turned on or off(registered or unregistered it's
-callback). It is done by sending special command to connector
-driver(it also registers itself with id={-1, -1}).
+selected ids will be turned on or off (registered or unregistered its
+callback).  It is done by sending a special command to the connector
+driver (it also registers itself with id={-1, -1}).
 
-As example of usage Documentation/connector now contains cn_test.c -
-testing module which uses connector to request notification and to
-send messages.
+As example of this usage can be found in the cn_test.c module which
+uses the connector to request notification and to send messages.
 
 /*****************************************/
 Reliability.
 /*****************************************/
 
-Netlink itself is not reliable protocol, that means that messages can
+Netlink itself is not a reliable protocol.  That means that messages can
 be lost due to memory pressure or process' receiving queue overflowed,
-so caller is warned must be prepared. That is why struct cn_msg [main
-connector's message header] contains u32 seq and u32 ack fields.
+so caller is warned that it must be prepared.  That is why the struct
+cn_msg [main connector's message header] contains u32 seq and u32 ack
+fields.
 
 /*****************************************/
 Userspace usage.
 /*****************************************/
+
 2.6.14 has a new netlink socket implementation, which by default does not
-allow to send data to netlink groups other than 1.
-So, if to use netlink socket (for example using connector) 
-with different group number userspace application must subscribe to 
-that group. It can be achieved by following pseudocode:
+allow people to send data to netlink groups other than 1.
+So, if you wish to use a netlink socket (for example using connector)
+with a different group number, the userspace application must subscribe to
+that group first.  It can be achieved by the following pseudocode:
 
 s = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
 
@@ -160,8 +163,8 @@ if (bind(s, (struct sockaddr *)&l_local, sizeof(struct sockaddr_nl)) == -1) {
 }
 
 Where 270 above is SOL_NETLINK, and 1 is a NETLINK_ADD_MEMBERSHIP socket
-option. To drop multicast subscription one should call above socket option
-with NETLINK_DROP_MEMBERSHIP parameter which is defined as 0.
+option.  To drop a multicast subscription, one should call the above socket
+option with the NETLINK_DROP_MEMBERSHIP parameter which is defined as 0.
 
 2.6.14 netlink code only allows to select a group which is less or equal to
 the maximum group number, which is used at netlink_kernel_create() time.
-- 
1.6.3.3

